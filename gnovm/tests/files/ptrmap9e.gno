// PKGPATH: gno.land/r/ptr_map
package ptr_map

type Foo struct {
	name string
}
type MyStruct struct {
	Name string
	Age  int
	foo  Foo
}

var a = MyStruct{Name: "alice", Age: 2, foo: Foo{name: "foo"}}
var foo2 = a.foo

func init() {
	a = MyStruct{Name: "bob", Age: 3, foo: Foo{name: "bar"}}
}

//func update() {
//}

func main() {
	//update()
	println(foo2)
}

// Output:
// (struct{("foo" string)} gno.land/r/ptr_map.Foo)

// Realm:
// switchrealm["gno.land/r/ptr_map"]
