# Collection Types

## Arrays

The type `[n]T` is an array of `n` values of type `T`.

```
var a [10]int
```

declares a variable `a` as an array of ten intergers. An array's length is part of its type, so arrays cannot be resized. Some examples:

```
package main
import "fmt"

func main() {
    var a [2]string
    a[0] = "Hello"
    a[1] = "World"
    fmt.Println(a[0], a[1])
    fmt.Println(a)
}
```

You can also set array entries at declaration:

```
primes := [6]int{2, 3, 5, 7, 11, 13}
fmt.Println(primes)
```

When declaring with entries you can use ellipsis to use an implicit length:

```
a := [...]string{"hello", "world!"}
```

To print arrays you need to use `%q` to print each element separately.

## Multi-dimensional Arrays

Go also supports multi-dimensional arrays.

```
var a [2][3]string
for i := 0; i < 2; i++ {
    for j := 0; j < 3; j++ {
        a[i][j] = fmt.Sprintf("row %d - column %d", i+1, j+1)
    }
}
fmt.Printf("%q", a)
```

## Slices

Slices wrap arrays to give a more genral interface to sequences of data. Slices hold references to an underlying array. If you assign one slice to another, both refer to the same array. If a function takes a slice argument, changes it makes to the elements of the slice will be visible to the caller, analogus to passing a pointer to the underlying array.

A slice points to an array of values and also includes a length. Slices can be resized since they are just a wrapper on top of another data structure.

`[]T` is a slice with elements of type `T`.

```
p := []int{2, 3, 5, 7, 11, 13}
```

You can also create an empty slice of specified length with `make`.

```
p:= make([]int, 3)
p[0] = 2
p[1] = 3
```

This allocates a zeroed array and returns a slice that refers to that array.

### Slicing a Slice

Slices can be re-slices, creating a new slice value that points to the same array. Slice notation is similar to python.

```
s[i:j]   // evaluates to a slice of the elements from i to j - 1, inclusive.
s[i:i]   // is an empty slice
s[i:i+1] // has one element
```

### Appending to a Slice

A slice is a reference to an array, but you will get a runtime error if you try to assign outside the length of the slice:

```
p := []int{}
p[0] = 2
```

will fail. You can do this with the append function:

```
p := []int{}
p = append(p, 2)
```

You can append more than one entry to a slice:

```
p := []int{}
p = append(p, 2, 3)
```

You can append a slice to another using an ellipsis:

```
p1 := []int{2, 3}
p2 := []int{5, 7}
p = append(p1, p2...)
```

The ellipsis is a built-in feature of Go that means that the element is a collection. We can't append an element of type slice of ints (`[]int`) to a slice of ints, only ints can be appended. Using the ellipsis (`...`) after the slice, indicates to the compiler to append the contents of the second slice.

### Other Slice Stuff

You can check the length of a slice by using `len`:

```
p := []int{2, 3, 5, 7}
fmt.Println(len(p))
```

The zero value of a slice is nil. A nill slice has lenght and capacity of 0.

```
var z []int
fmt.Println(z, len(z), cap(z)) // [] 0 0
if z == nil {
    fmt.Println("nill!")
}

```

> More info on [slices](https://blog.golang.org/slices-intro).
> Two-dimensional [slices](https://golang.org/doc/effective_go.html#two_dimensional_slices).

## Maps

Maps are similar to hashtables or dictionaries in other languages. They map keys to values. Define a map with `map[keytype]valuetype{}`:

```
p := map[string]int{
    "Two":   2,
    "Three": 3,
    "Five":  5,
    "Seven": 7,
}

fmt.Printf("%#v", p)
```

When not using map literals maps must be created with make (not new) before use. The nil map is empty and connot be assigned to.

```
type Vertex struct {
    Lat, Long float64
}

var m map[string]Vertex

m = make(map[string]Vertex)
m["Bell Labs"] = Vertex{40, -74}
fmt.Println(m["Bell Labs"])
```

When using map literals, if the top-level type is just the type name, you can omit if from the elements of the literal.

```
type Vertex struct {
    Lat, Long float64
}

var m map[string]Vertex{
    "Bell Labs": {40, -74},
    "Google": {37, -122},
}

```

### Mutating Maps

Insert or update an element in map m: `m[key] = elem`

Retrieve an element: `elem = m[key]`

Delete an element: `delete(m, key)`

Test that a key is present with a two-value assignment: `elem, ok := m[key]`

If `key` is in `m`, `ok` is true. If not, `ok` is false and `elem` is the zero value for the map's element type. When a key is not present the zero value for the maps element type is returned.

## Ranges in For Loops

The `range` form of a for lop iterates over all the elements in a slice or map.

```
p := []int{2, 3, 5, 7}
for i, v := range p {
    fmt.Printf("%d %d\n", i, v)
}
```

You can drop values with `_` like in python.

```
p := []int{2, 3, 5, 7}
for _, v := range p {
    fmt.Printf("%d\n", v)
}
```

`break` and `continue` work as in other languages.

Range can also be used on maps(like python dicts). The first parameter is the key and second is the value.



