package main

func foo(a *int) {
	println(*a)
}

func main() {
	x := 1
	foo(&x)
}
