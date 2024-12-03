// PKGPATH: gno.land/r/ptr_map
package ptr_map

type MyStruct struct {
	Name string
	Age  int
}

var m = make(map[MyStruct]string)

func init() {
	i1 := MyStruct{Name: "alice", Age: 2}
	m[i1] = "first key"
	println(m[MyStruct{Name: "alice", Age: 2}])
}

func main() {
	println(m[MyStruct{Name: "alice", Age: 2}])

	delete(m, MyStruct{Name: "alice", Age: 2})

	println(m[MyStruct{Name: "alice", Age: 2}] == "")
}

// Output:
// first key
// first key
// true

// Realm:
// switchrealm["gno.land/r/ptr_map"]
// u[15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:3]={
//     "List": {
//         "List": []
//     },
//     "ObjectInfo": {
//         "ID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:3",
//         "ModTime": "5",
//         "OwnerID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:2",
//         "RefCount": "1"
//     }
// }
// d[15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:5]
