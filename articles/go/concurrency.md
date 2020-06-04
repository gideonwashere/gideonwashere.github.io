# Concurrency

Go has many interesting features that help ease concurrent programming. Instead of locking resources, Go encourages a different approach to concurrency in which shared values are passed around on channels and are never actively shared by separate threads of execution. Only one goroutine has access to the value at any given time. Thus, by design, data races cannot occur. Here is a slogan to capture this idea:

> Do not communicate by sharing memory; instead, share memory by communicating.

This approach can be taken too far however. Reference counts may be best done by putting a mutex around an interger variable, for instance. But as a high-level approach, using channels to control access makes it easier to write clear, correct, concurrent programs. Go's approach to concurrency originates in [Hoare's Communicating Sequential Process (CSP)](https://en.wikipedia.org/wiki/Communicating_sequential_processes), it can be thought of as a type-safe generalizaion of Unix pipes.

## Goroutines

A goroutine is a lightweigh thread managed by the Go runtime. Goroutines can be functions or methods that run concurrently with other functions or methods

```
go f(x, y, z)
```

starts a new goroutine running the function `f(x, y, z)`. The evaluation of `f`, `x`, `y` and `z` happens in the current goroutine, and the execution of `f` happens in a new goroutine.

Goroutines run in the same address space, so access to shared memory must be synchronized. The [sync](https://golang.org/pkg/sync/) package provides useful primitives, although you won't need them much in Go as there are other primitives.

```
package main

import (
    "fmt"
    "time"
)

func say(s string) {
    for i := 0; i < 5; i++ {
        time.Sleep(100 * time.Millisecond)
        fmt.Println(s)
    }
}

func main() {
    go say("world") // parallel execution of say() calls
    say("hello")
}
```

## Channels

Channels are pipes through which you can send and receive values using the channel operator, `<-`.

```
ch <- v     // Send v to channel ch.
v := <-ch   // Recive from ch, and
            // assign value to v.
```

> **Note:** The data flows in the direction of the arrow.

Like maps and slices, channels must be created before use:

```
ch := make(chan int)
```

By default, send and receive calls block until the other side is ready. This allows goroutines to synchronize without explicit locks or condition variables.

```
package main

import "fmt"

func sum(a []int, c chan int) {
    sum := 0
    for _, v := range a {
        sum += v
    }
    c <- sum // send sum to c
}

func main() {
    a := []int{7, 2, 8, -9, 4, 0}

    c := make(chan int)
    go sum(a[:len(a)/2], c)
    go sum(a[len(a)/2:], c)
    x, y := <-c, <-c // receive from c

    fmt.Println(x, y, x+y)
}
```

In the example above, all lines before line 17 will execute sequentially. Line 17 will invoke a non-blocking go-routine for the sum function and will pass the channel c and the first half of the array in it. As the code does not block, the function invoked by line 17 and line 18 of the main program executes parallelly. Line 18 will take the second half of the array and the channel c as inputs.

Hence, both the go-routines invoked in line 17 and 18 will execute in parallel.

Line 19 will not execute until we receive a value from the channels. When the go-routines invoked by line 17 and 18 will pass values to the channels ( as specified by c <- sum), line 19 of the main will then execute.

## Buffered Channels

Channels can be buffered. Provide the buffer length as the second argument to `make` to initialize a buffered channel: `ch := make(chan int, 100)`

Sends to a buffered channel block only when the buffer is full. Receives block when the buffer is empty.

Beware!

```
func main() {
    c := make(chan int, 2)
    c <- 1
    c <- 2
    c <- 3
    fmt.Println(<-c)
    fmt.Println(<-c)
    fmt.Println(<-c)
}
```

will result in deadlock, because we overfilled the buffer without giving the code a chance to read/remove a value from the channel.

## Range and Close

A sender can close a channel to indicate that no more values will be sent. Receivers can test whether a channel has been closed by assigning a second parameter to the recieve expression:

```
c := make(chan int, 10)
close(c) // close channel c
```

```
v, ok := <-ch
```

`ok` is false if ther are no more values to recieve and the channel is closed. The loop `for i := range ch` receives values from the channel repeatedly until it is closed.

> **Note:** Only the sender should close a channel, never the receiver. Sending on a closed channel will cause a panic.

> **Note:** Channels aren't like files; you don't usually need to close them. CLosing is only necessary when the receiver must be told there are no more values coming, such as to terminate a range loop.

## Select

The `select` statement lets a goroutine wait on multiple communication operations. A `select` blocks until one of its cases can run, then it executes that case. It chooses one at random if multiple are ready.

```
select { // wait on value for c or quit
case c <- x:
    // do something
case <-quit:
    return
default:
    // do something
}
```

The `default` case is run if no other case is ready. You can use `default` case to try a send or receive without blocking:

```
select {
case i := <-c:
    // use i
default:
    // do this instead of blocking
}
```

Example in action:

```
package main

import (
    "fmt"
    "time"
)

func main() {
    tick := time.Tick(100 * time.Milisecond)
    boom := time.Tick(500 * time.Milisecond)
    for {
        select {
        case <-tick:
            fmt.Println("tick.")
        case <-boom:
            fmt.Println("BOOM!")
            return
        default:
            fmt.Println("    .")
            time.Sleep(50 * time.Millisecond)
        }
    }
}
```

Default will execute until one of the cases is ready. The moment a case is ready it is run. The select command will block until the case is run.

### Timeout Example

```
package main

import (
    "fmt"
    "log"
    "net/http"
    "time"
)

func main() {
    response := make(chan *http.Response, 1)
    errors := make(chan *error)

    go func() {
        resp, err := http.Get("http://no.site.com")
        if err != nil {
            errors <- &err
        }
        response <- resp
    }()
    for {
        select {
        case r := <-response:
            fmt.Printf("%s", r.Body)
            return
        case err := <-errors:
            log.Fatal(*err)
        case <-time.After(200 * time.Millisecond):
            fmt.Println("Timed Out!")
            return
        }
    }
}
```

If there is no response or error after 200ms the select will time out.
