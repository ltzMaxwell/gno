// PKGPATH: gno.land/r/ptr_map
package ptr_map

type MyStruct struct {
	arr [2]int
}

var MS MyStruct

func main() {
	var a [2]int
	a[0] = 1
	a[1] = 2

	MS.arr = a
}

// Output:
