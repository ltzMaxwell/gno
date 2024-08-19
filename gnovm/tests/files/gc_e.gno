package main

func foo(a interface{}) {
	println(a)
}

func main() {
	x := 1
	foo(&x) // no escape
}
