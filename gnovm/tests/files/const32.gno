package main

import "fmt"

func main() {
	const t = len([]string{})
	fmt.Println(t)
}

// Error:
// main/files/const32.gno:6:8: (const (len func(x interface{})( int)))([](const-type string){}) (value of type int) is not constant
