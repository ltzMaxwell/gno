package main

import "std"
import "fmt"

type Target struct {
	Description string
	Name string
}

func main(){
	t := &Target{
		Description: "test",
		Name: "kimi",
	}
	r := std.Marshal2(t)
	fmt.Printf("%s \n", r)
	println(len(r))
	h := std.Hash(r)
}
// Error:
// runtime error: invalid memory address or nil pointer dereference