# Control Flow

## If Statements

If statements in go are similar to C. Variables declared by the statement are only in scope until the end of the `if`. Variables declared inside an `if` short statement are also available inside the `else` blocks.

```
if answer != 42 {
    return "Wrong"
}
```

Example of an `if` short statement with a variable declared within the statement.

```
if err := foo(); err != nil {
    panic(err)
}
```

Full example:

```
func pow(x, n, lim float64) float64 {
    if v := math.Pow(x, n); v < lim {
        return v
    } else {
        fmt.Printf("%g >= %g\n", v, lim)
    }
    // v is now unavailable
    return lim
}
```

## For Loops

The `for` loop is the only loop construct in go (no `while`). They are similar to C, you can leave the pre and post statements empty.

```
for i := 0; i < 10; i++ {
    sum += i
}
```

Example of `for` loop without pre/post statements:

```
for ; sum < 1000; { // loop until sum >= 1000
    sum += sum
}
```

The `;` can also be ommited, this works the same as a `while` loop:

```
sum := 1
for sum < 1000 {
    sum += sum
}
```

You can also do infinite loops, this is like `while true`:

```
for {
    // do something forever
}
```

## Switch Statements

Switch statements are an alternative to multiple `if` `else` statements.

```
y = x % 2
switch y {
case 0:
    // do something
case 1:
    // do something
}
```

Some features of go switch statements:

* You can only compare values of the same type.
* You can set an optional `default` statement to be executed if all the others fail.
* You can use an expression in the `case` statement, for instance you can calculate a value to use in the case:

```
switch x {
case 0:
    // do something
case 3 - 2:
    // do something
}
```

* You can have multiple values in a `case` statement:

```
switch x {
case 0, 3, 4:
    // do something
case 1, 2:
    // do something
defalut:
    // do something
}
```

* You can execute all the following statements after a match using the `fallthrough` statement.
* You can use `break` inside your matched statement to exit the switch processing:

```
switch x {
case 0:
    // do something
    break // stop checking cases if here
case 1:
    // do something
    fallthrough // following cases with be executed as well
defalut:
    // do something
}
```

