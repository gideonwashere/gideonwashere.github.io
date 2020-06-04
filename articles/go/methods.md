# Methods

Go doesn't have classes, but types ans methods allow for an object-oriented style of programming. Go does not support inheritance, but instead has the concept of interface.

You can define methods on struct types. The method receiver (paretn 'object') appears in its own argument list between the `func` keyword and the method name.

```
type User struct {
    FirstName, LastName string
}

func (u User) Greeting() string {
    return fmt.Sprintf("Dear %s $s", u.FirstName, u.LastName)
}
```

Note that methods are defined outside of the struct. In fact, you can define a method on `any` type you define in your package, not just structs. You cannot define a method on a type from anouther package, or on a basic type.

Since methods can be defined anywhere in a package here is a recommended organization for you code.

```
package main

// list of packages to import
import (
    "fmt"
)

// list of constants
const (
    ConstExample = "const before vars"
)

// list of variables
var (
    ExportedVar = 42
    nonExportedVar = "so say we all"
)

// Main type(s) for the file,
// Try to keep the lowest amount of structs per file when possible
type User struct {
    FirstName, LastName string
    Location            *UserLocation
}

type UserLocation struct {
    City    string
    Country string
}

// List of functions
func NewUser(firstName, lastName string) *User {
    return &User{
        FirstName: firstName,
        LastName: lastName,
        Location: &UserLocation{
            City:    "Colony 01",
            Country: "Mars",
        },
    }
}

// List of methods
func (u *User) Greeting() string {
    return fmt.Sprintf("Dear %s %s", u.FirstName, u.LastName)
}

// main function if applicable
func main() {
    us := NewUser("Matt", "Damon")
    fmt.Println(us.Greeting())
}
```

## Type Aliasing

To define methods on a type you don't 'own', you need to define an alias for the type you want to extend. Type alliasing declares a new name to be used as a substitute for a previously known type. It does not introduce a new type, neither does it change the meaning of the existing type name.

```
type MyStr string // aliasing string as MyStr

func (s MyStr) Uppercase() string {
    return strings.ToUpper(string(s))
}
```

## Method Receivers

Methods can be associated with aliased types, a named type (like `User`) or a pointer to a named type (like `*User`). There are two reasons to use a pointer reciever. First, to avoid copying the value on each method call.

```
func (u User) Greeting() string {} // direct reciever

func (u *User) Greeting() string {} // pointer reciever
```

Go passes everything by value so when the first greeting is called it will copy the `User` struct. When using the pointer, only the pointer is copied which is much faster.

The second reason to define a method on a pointer reciever is if you want the method to modify the original reciever.


