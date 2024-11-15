// PKGPATH: gno.land/r/ptr_map
package ptr_map

type MyStruct struct {
	Name string
}

var (
	arr = [2]*MyStruct{}
	i1  = &MyStruct{Name: "alice"}
	i2  = &MyStruct{Name: "bob"}
)

func init() {
	arr[0] = i1
	arr[1] = i2
}

func main() {
	println(arr[0].Name)
	println(arr[1].Name)
}

// Output:
// alice
// bob
