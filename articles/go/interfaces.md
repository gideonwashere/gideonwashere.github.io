# Interfaces

An inerface type is defined by a set of methods. A value of interface type can hold any value that implements those methods. Interfaces increase the flexability as well as the scalability of the code. Hence, it can be used to achieve polymorphism in Go. Interface does not require a particular type, specifying that only some behavior is needed, which is defined by a set of methods.

Here is an example using the greeting function. We define a function called Greet which takes a param of interface type `Namer`. `Namer` is a new interface we defined which only defines one method: `Name()`. So `Greet()` will accept as param any value which has a `Name()` method defined.

To make `User` struc implement the inerface, we define a `Name()` method. We can now call `Greet` and pass our pointer to `User` type.

```
package main

import (
	"fmt"
)

type User struct {
	FirstName, LastName string
}

func (u *User) Name() string {
	return fmt.Sprintf("%s %s", u.FirstName, u.LastName)
}

type Namer interface {
  Name() string //The Namer interface is defined by the Name() method
}

func Greet(n Namer) string {
	return fmt.Sprintf("Dear %s", n.Name())
}

func main() {
	u := &User{"Matt", "Aimonetti"}
	fmt.Println(Greet(u))
}
```

Now that we have an interface we can define a new type that would implement the same interface and our `Greet` funciton would still work.

```
package main

import (
	"fmt"
)

type User struct {
	FirstName, LastName string
}

func (u *User) Name() string {
	return fmt.Sprintf("%s %s", u.FirstName, u.LastName)
}

type Customer struct {
    Id       int
    FullName string
}

func (c *Customer) Name() string {
    reutrn c.FullName
}

type Namer interface {
    Name() string //The Namer interface is defined by the Name() method
}

func Greet(n Namer) string {
	return fmt.Sprintf("Dear %s", n.Name())
}

func main() {
	u := &User{"Matt", "Aimonetti"}
	fmt.Println(Greet(u))
	c := &Customer{42, "John Doe"}
	fmt.Println(Greet(c))
}
```

## Satisfying Interfaces

A type implements an interface by implementing the methods that it contains. There is no explicit declaration of intent. The interfaces are satisfied implicitly through its methods.

Implicit interfaces decouple implementation packages form the packages that define the interfaces: neither depends on the other. It also encourages the definition of precise interfaces, because you don't have to find every implementation and tag it with the new interface name.

```
type Reader interface {
    Read(b []byte) (n int, err error)
}

type Writer interface {
    Write(b []byte) (n int, err error)
}

type ReadWriter interface {
    Reader
    Writer
}

func main() {
    var w Writer

    // os.Stdout implements Writer
    w = os.Stdout

    fmt.Fprintf(w, "hello, writer\n")
}
```

`Pacakge io` has Reader and Writer defined already so you don't have to.

## Returning Errors

We can display error messages within interfaces. An error is anything that can describe itself as an error string. The idea is captured by the predefined, built-in interface type, error, with its single method, `Error`, returning a string:

```
type error interface {
    Error() string
}
```

The `fmt` package's various print routines automatically know to call the methods when asked to print an error.

```
package main

import (
    "fmt"
    "time"
)

type MyError struct {
    When time.Time
    What string
}

func (e *MyError) Error() string {
    return fmt.Sprintf("at %v, %s", e.When, e.What)
}

func run() error {
    return &MyError{
        time.Now(),
        "it didn't work",
    }
}

func main() {
    if err := run(); err != nil {
        fmt.Println(err)
    }
}
```

