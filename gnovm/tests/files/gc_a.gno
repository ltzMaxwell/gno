package main

var global *int

func main() {
	x := 1      // heapDefine
	global = &x // x should be heapItem, peek out into global
}

// Preprocessed:
// file{ package main; var global<!VPBlock(2,0)> *((const-type int)); func main() { x<!VPBlock(1,0)> := (const (1 int)); global<VPBlock(3,0)> = &(x<VPBlock(1,0)>) } }
