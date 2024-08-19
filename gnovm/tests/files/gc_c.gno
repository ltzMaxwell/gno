package main

func main() {
	x := 1
	println(&x) // should not escape
}
