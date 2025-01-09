package main

var x = "a"

const v = len(x)

func main() {
	println("ok")
}

// Error:
// main/files/const50.gno:5:7: (const (len func(x interface{})( int)))(x<VPBlock(2,0)>) (value of type int) is not constant
