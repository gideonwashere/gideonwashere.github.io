# The Basics

Link to the [Go language specification](https://golang.org/ref/spec).

## Variable Declaration

The `var` keyword is used to declare a variable. A variable is declared with `var <name> <type>`. Multiple variables can be declared at the same time by encolsing them in (). All of the following are valid

```
var name     string
var location string
var age      int
```

```
var (
    name     string
    location string
    age      int
)
```

```
var (
    name, location string
    age            int
)
```

## Variable Initialization

A `var` declaration can include initializers.


```
var (
    name string     = "Harry Potter"
    age  int        = 17
    location string = "Hogwarts"
)
```

If an initializer is present, the type can be omitted. The compiler will infer the variable's type.

```
var (
    name     = "Harry Potter"
    age      = 17
    location = "Hogwarts"
)
```

Multiple variables can be initilized at once.

```
var (
    name, location, age = "Harry Potter", "Hogwarts", 17
)
```

Inside a function, the `:=` short assignment operator can be used in place of a `var` delclaration with implicit type.

```
package maiin
import "fmt"

func main() {
    name, location := "Harry Potter", "Hogwarts"
    age := 32
    fmt.Printf("%s age %d from %s ", name, age, location)
}
```

A variable can contain any type, including functions:

```
func main() {
    action := func() {
        // action is a variable that contains a function
    }
    action()
}
```

Outside a function, every construct begins with a keyword (`var`, `func`, and so on) and the `:=` is not available.

> More available in [Go's declaration syntax](https://blog.golang.org/declaration-syntax).

## Constant Declaration

Constants are declared like variables, but with the `const` keyword.

Constants can only be a **character**, **string**, **boolean**, or **numeric** values and cannot be declared using the `:=` syntax. An *untyped* constant takes the type neede by its context.

```
const Pi = 3.14159
const (
    StatusOK        = 200
    StatusCreated   = 201
    StatusAccepted  = 202
)
```

## Printing

While you can print the value of a variable or constatn using the built-in `print` and `println` functions, the more idiomatic and flexible way is to use the `fmt` package.

```
package main
import "fmt"

func main() {
    number := 6
    fmt.Println(number)
}
```

`fmt.Println` prints the variable and appends a newline. `fmt.Printf` is used when you want to print more than one value and/or use format specifiers.


```
package main
import "fmt"

func main() {
    name := "Caprica-Six"
    aka := fmt.Sprintf("Number %d", 6)
    fmt.Printf("%s is also known as %s", name, aka)
}
```

> `fmt` [package documentation](https://golang.org/pkg/fmt/#hdr-Printing) here.

## Packages

Every Go prigram is made up of packages. Programs start running in the package `main`. When writing an executable (versus a library), you need to define a `main` package and a `main()` function which will be the entry point to your software.

By convention, the package name is the same as the last element of the import path. For instance, the "math/rand" package comprises files that begin with the statement package rand.

```
import "fmt"
import "math/rand"
```
or
```
import (
    "fmt"
    "math/rand"
)
```

> More info on [packages](https://tour.golang.org/basics/1) and [imports](https://tour.golang.org/basics/2).

Here are some examples showing how to use imports.

```
package main

import (
    "fmt"
    "math/rand"
)

func main() {
    fmt.Println("My favorite number is", rand.Intn(10))
}
```
```
package main

import (
    "fmt"
    "math"
)

func main() {
    fmt.Println("Now you have %g problems.", math.Sqrt(7))
}
```

Usually, nonstandard lib packages are namespaces using a *web url*. For example there is some Rails logic proted to Go, including the cryptography code used in Rails 4. The source code is hosted on GitHub containing a few pacages, in the following repository: [https://github.com/mattetti/goRailsYourself](https://github.com/mattetti/goRailsYourself).

To import the crypto package, you would need to use the following import statement:

```
import "github.com/mattetti/goRailsyourself/crypto"
```

## Code Location

The path `github.com/mattetti/goRailsYourself/crypto` tells the compiler to import the crypto package. It doesn’t mean that the compiler will automatically pull down the repository, you need to pull down the code yourself. The easiest way is to use the `go get` command provided by Go.

```bash
go get github.com/mattetti/goRailsYourself/crypto
```

This command will pull down the code and put it in your *Go path*. When installing Go, you need set the `GOPATH` environment variable. All the Go binaries and libraries are stored in `$GOPATH`. That’s also where you should store your code (your workspace).

> By default `$GOPATH` is set to `~/go`.

Best practice is to specify three folders in your GOPATH:

* The `bin` folder contains Go compiled binaries. It's generally nice to add this to your system path.
* The `pkg` folder contains compiled version of available libraries so the compiler can link against them without recompiling them.
* The `src` folder contains all the Go source code organized by import path.

When atarting a new program or library, it is recommended to do so inside the `src` folder, using a fully qualifed path (e.g. `github.com/<username>/<project name>`)

## Exports

After importing a package, you can refer to the names it exports (variables, methods, and functions available from outside the package). In Go, a name is exported if it begins with a capital letter. Essentially like public methods. Names that begin with lower case letters are not exported essentially private functions.

## Functions

When declaring functions, the type comes after the variable name in the inputs. The return type(s) are then specified after the function name and inputs, before writing the definition. Functions can be defined to return any number of values and each of them are put here.

```
package main
import "fmt"

func add(x int, y int) int {
    return x + y
}

func main() {
    fmt.Println(add(5, 10))
}
```

One type declaration can also be applied to multiple parameters.

```
package main
import "fmt"

func add(x, y int) int {
    return x + y
}

func main() {
    fmt.Println(add(5, 10))
}
```

Functions can return multiple values.

```
func example(input string) (string, string) {
    // do stuff

    return string1, string2
}
```

## Named Results

Functions take parameters. In Go, functions can return multiple "result parameters", not just a single value. They can be named and act just like variables. If the result arameters are named, a return statement without arguments returns the current values of the results.

```
func example(x, y int) (out1, out2 int) {
    out1 = x
    out2 = y

    return // returns out1 and out2
}
```

Although this is cool, named results tend to cause more confusion than clarity. So, thier use is generally discouraged.

## Pointers

Go does have pointers, but no pointer arithmetic. Struct fields can be accessed through a struct pointer. The indirection through the pointer is **transparent** (you can directly call fields and methods on a pointer)

Note that by defaout Go passes argumetns by value, if you want to pass arguments by reference, you need to pass pointers (or use a structure using reference values like *slices* and *maps*.

To get a pointer to a value, use the `&` symbol in front of the value; to dereference a pointer, use th `*` symbol (like C).

Methods are often defined on pointers and not values, so you will often store a pointer in a variable like so:

```
client := &http.Client{}
resp, err := client.Get("http://example.com")
```

## Mutability

In Go, only constants are immutable. However, because arguments are passed by value, a function recieving a value argument and mutating it, won't mutate the original value. To mutate a passed value, we need to pass it by reference, using a pointer.
