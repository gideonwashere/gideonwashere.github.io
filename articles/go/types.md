# Types

Go is a strongly typed language, and has the following built in types.

Common:

* `bool` true or false
* `string` an array of characters

Numeric:

* `uint` unsigned int either 32 or 64 bits based on processor
* `int` signed int same size as uint
* `uintptr` an unsiged int large enough to store memory address
* `uint8` `uint16` `uint32` `uint64` unsigned int specified bits
* `int8` `int16` `int32` `int64` signed int specified bits
* `float32` `float64` IEEE-754 32/64-bit floating-point numbers
* `complex64` `complex128` complex number with float32/64 real and imaginary parts
* `byte` alias for unit8
* `rune` alias for int32 (represents a unicode code point)

## Type Conversion

Converting values from one type to another is fairly simple in Go. The expression `T(v)` converts the value `v` to the type `T`.

```
var i int = 42
var f float64 = float64(i)
var u uint = uint(f)

// more simply

i := 42
f := float64(i)
u := uint(f)
```

Go assignment between items of different type requires an explicit conversion which means that you manually need to conver types if you are passing a variable to a function expecting anouther type.

## Type Assertion

Type assertion is used when converting a variable's type to another specific type. A type assertion takes a value and tries to create another version in the specified explicit type.

> COME BACK TO THIS AFTER LEARNING ABOUT INTERFACES

## Structs

Like in C, a struct is a collection of fields/properties. You can define new types as structs or interfaces. Structs can be though of as light classes that support composition but not inheritance. Note that only exported fields (capitalized) can be accessed from outside of a package.

A struct literal sets a newly allocated struct value by listing the values of its fields. You can list just a subset of field by using the `"Name:" syntax` (the order of named fields is irrelevant when using this syntax). The special prefix `&` constructs a pointer to a newly allocated struct.

```
package main

import (
    "fmt"
    "time"
)

type Party struct {
    Lat float64
    Lon float64
    Date time.Time
}

func main() {
    fmt.Println(Party{
        Lat: 34.012,
        Lon: -118.495,
        Date: time.Now(),
    })
}
```

Struct literals:

```
type Point struct {
    X, Y int
}

var (
    p = Point{1, 2}     // has type Point
    q = &Point{1, 2}    // has type *Point
    r = Point{X: 1}     // Y:0 is implicit
    s = Point{}         // X:0 and Y:0
}
```

Struct fileds can be accessed using dot notation:

```
package main
import (
    "fmt"
    "time"
)

type Party struct {
    Lat, Lon float64
    Date     time.Time
}

func main() {
    event = Party{
        Lat: 34.012,
        Lon: -118.495,
    }
    event.Date = time.Now()
    fmt.Printf("Event on %s, location (%f, %f)",
        event.Date, event.Lat, event.Lon)
}
```

## Initializing

Go supports the `new` expression to allocate a zeroed value of the requested type and to return a pointer to it.

```
x := new(int)
```

A common way to "initialize" a variable containing a struct or a reference to one, is to create a struct literal. Another option is to create a constructor. This is usually done when the zero value isn't good enough and you need to set some defalut field values.

```
type Party struct {
    // stuff
}

// These are equivalent
x := new(Party)
x := &Party{}
```

Note that slices, maps and channels are usually allocated using `make` so the data structure these types are built upon can be initialized.

Refernces:

* [Allocation with `new`](https://golang.org/doc/effective_go.html#allocation_new)
* [Allocation with `make`](https://golang.org/doc/effective_go.html#allocation_make)
* [Composite Literals](https://golang.org/doc/effective_go.html#composite_literals)

## Composition vs Inheritance

Go does not support inheritance, but does offer composition and interfaces. Composition is also known as embedding.

> [Go Blog article on composition](https://golang.org/doc/effective_go.html#embedding)

Consider the two structs:

```
type User struct {
    Id          int
    Name        string
    Location    string
}

type Player struct {
    Id          int
    Name        string
    Location    string
    GameId      int
}

```

Player is almost the same as User with one extra attribute. To minimize data overlap, we can simplify by composing our struct.

```
type User struct {
    Id             int
    Name, Location string
}

type Player struct {
    User
    GameId      int
}
```

`Player` can be initialized in two different ways.

Using dot notation:

```
p := Player{}
p.Id = 42
p.Name = "Jake"
p.Location = "SF"
p.GameId = 100
```

or using struct literal:

```
p := Player{
    User{Id: 42, Name: "Jake", Location: "SF"},
    100,
}
```

Methods of the `User` struct will also be available to the `Player` struct. `Player` will also automatically implement any interfaces implemented by `User`.
