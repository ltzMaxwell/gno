package main

import "math"

func main() {
	const pi = len(math.Pi)
	println(pi)
}

// Error:
// main/files/const38a.gno:6:8: (const (len func(x interface{})( int)))((const (3.141592653589793 float64))) (value of type int) is not constant
