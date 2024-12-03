// PKGPATH: gno.land/r/ptr_map
package ptr_map

type MyStruct struct {
	Name string
	Age  int
}

var (
	m = map[MyStruct]string{}
)

func main() {
	i1 := MyStruct{Name: "alice", Age: 2}
	m[i1] = "first key"
	println(m[i1])

	delete(m, i1)
	println(m[i1] == "")
}

// Output:
// first key
// true

// Realm:
// switchrealm["gno.land/r/ptr_map"]
// c[15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:5]={
//     "Fields": [
//         {
//             "Path": {
//                 "Depth": 0,
//                 "Index": 0,
//                 "Name": "",
//                 "Type": 0
//             },
//             "T": {
//                 "@type": "/gno.PrimitiveType",
//                 "value": "16"
//             },
//             "V": {
//                 "@type": "/gno.StringValue",
//                 "value": "alice"
//             }
//         },
//         {
//             "N": "AgAAAAAAAAA=",
//             "Path": {
//                 "Depth": 0,
//                 "Index": 0,
//                 "Name": "",
//                 "Type": 0
//             },
//             "T": {
//                 "@type": "/gno.PrimitiveType",
//                 "value": "32"
//             }
//         }
//     ],
//     "ObjectInfo": {
//         "ID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:5",
//         "ModTime": "0",
//         "OwnerID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:3",
//         "RefCount": "1"
//     }
// }
// u[15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:3]={
//     "List": {
//         "List": []
//     },
//     "ObjectInfo": {
//         "ID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:3",
//         "ModTime": "4",
//         "OwnerID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:2",
//         "RefCount": "1"
//     }
// }
