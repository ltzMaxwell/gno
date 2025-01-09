package main

import "fmt"

func main() {
	const t = 1 + 2 + len([]string{})
	fmt.Println(t)
}

// Error:
// main/files/const32.gno:6:8: (const (len func(x interface{})( int)))([](const-type string){}) (variable of type (const (len func(x interface{})( int)))) is not constant
