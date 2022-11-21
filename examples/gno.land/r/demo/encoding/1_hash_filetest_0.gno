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
	r, ok := std.Marshal1(t)
	if ok{
		fmt.Printf("%s \n", r)
		println(len(r))
	}else{
		println("error")
	}
	h := std.Hash(r)
}
// Output:
// {"TV":{"T":{"PkgPath":"main","Name":"Target","Base":{"PkgPath":"main","Fields":[{"Name":"Description","Type":16,"Embedded":false,"Tag":""},{"Name":"Name","Type":16,"Embedded":false,"Tag":""}]},"Methods":null},"V":{"ID":{"PkgID":{"Hashlet":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]},"NewTime":0},"Hash":{"Hashlet":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]},"OwnerID":{"PkgID":{"Hashlet":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]},"NewTime":0},"ModTime":0,"RefCount":0,"Fields":[{"T":16,"V":"test","N":[0,0,0,0,0,0,0,0]},{"T":16,"V":"kimi","N":[0,0,0,0,0,0,0,0]}]},"N":[0,0,0,0,0,0,0,0]},"Base":null,"Index":0}
// 608