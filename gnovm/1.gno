package main

type Foo struct{ Name string }

func (f *Foo) Bar(param string) string {
	return "ok"
}

func main() {
	const a = len((*Foo).Bar)
	println(a)
}
