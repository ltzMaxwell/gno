// PKGPATH: gno.land/r/ptr_map
package ptr_map

type MyStruct struct {
	Name string
}

var (
	arr = [1]*MyStruct{}
	//arr = [1]MyStruct{}
)

func main() {
	i1 := &MyStruct{Name: "alice"}
	//i1 := MyStruct{Name: "alice"}
	arr[0] = i1
	println("ok")
}

// Output:
// ok
