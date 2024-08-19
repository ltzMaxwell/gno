package main

var global *int

func foo(a *int) {
	println(*a)
	global = a // Store the pointer in a global variable, making `x` escape
}

func main() {
	x := 1
	foo(&x)
}

// Preprocessed:
// file{ package main; var global<!VPBlock(2,0)> *((const-type int)); func foo(a *((const-type int))) { (const (println func(xs ...interface{})()))(*(a<VPBlock(1,0)>)); global<VPBlock(3,0)> = a<VPBlock(1,0)> }; func main() { x<!VPBlock(1,0)> := (const (1 int)); foo<VPBlock(3,1)>(&(x<VPBlock(1,0)>)) } }
