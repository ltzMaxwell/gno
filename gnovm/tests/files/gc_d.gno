package main

var foo *Foo

type Bar struct{}

type Foo struct {
	f *Bar
}

func main() {
	ff := &Foo{f: &Bar{}}
	foo = ff
}
