package main

import "std"

func main() {
	const l = len(std.B)
	println(l)
}

// Error:
// main/files/const38c.gno:6:8: (const (len func(x interface{})( int)))(std<VPBlock(2,0)>.B) (value of type int) is not constant
