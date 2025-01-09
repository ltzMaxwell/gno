package main

func main() {
	const a = len(map[string][]int{"arr": {1, 2}})
	println("ok", a)
}

// Error:
// main/files/const48.gno:4:8: (const (len func(x interface{})( int)))(map[(const-type string)] [](const-type int){(const ("arr" string)): (const-type []int){(const (1 int)), (const (2 int))}}) (value of type int) is not constant
