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

var m = make(map[MyStruct]string)

var foo2 Foo

func init() {
	i1 := MyStruct{Name: "alice", Age: 2, foo: Foo{name: "foo"}}
	m[i1] = "first key"
	println(m[i1])
	foo2 = i1.foo
}

func main() {
	delete(m, MyStruct{Name: "alice", Age: 2, foo: Foo{name: "foo"}})

	println(m[MyStruct{Name: "alice", Age: 2, foo: Foo{name: "foo"}}] == "")
}

// Output:
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
//         "ModTime": "8",
//         "OwnerID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:2",
//         "RefCount": "1"
//     }
// }
// u[15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:2]={
//     "Blank": {
//         "Path": ""
//     },
//     "ObjectInfo": {
//         "ID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:2",
//         "IsEscaped": true,
//         "ModTime": "8",
//         "RefCount": "2"
//     },
//     "Parent": null,
//     "Source": {
//         "@type": "/gno.RefNode",
//         "BlockNode": null,
//         "Location": {
//             "Column": "0",
//             "File": "",
//             "Line": "0",
//             "PkgPath": "gno.land/r/ptr_map"
//         }
//     },
//     "Values": [
//         {
//             "Path": "",
//             "T": {
//                 "@type": "/gno.TypeType"
//             },
//             "V": {
//                 "@type": "/gno.TypeValue",
//                 "Type": {
//                     "@type": "/gno.DeclaredType",
//                     "Base": {
//                         "@type": "/gno.StructType",
//                         "Fields": [
//                             {
//                                 "Embedded": false,
//                                 "Name": "name",
//                                 "Tag": "",
//                                 "Type": {
//                                     "@type": "/gno.PrimitiveType",
//                                     "value": "16"
//                                 }
//                             }
//                         ],
//                         "PkgPath": "gno.land/r/ptr_map"
//                     },
//                     "Methods": [],
//                     "Name": "Foo",
//                     "PkgPath": "gno.land/r/ptr_map"
//                 }
//             }
//         },
//         {
//             "Path": "",
//             "T": {
//                 "@type": "/gno.TypeType"
//             },
//             "V": {
//                 "@type": "/gno.TypeValue",
//                 "Type": {
//                     "@type": "/gno.DeclaredType",
//                     "Base": {
//                         "@type": "/gno.StructType",
//                         "Fields": [
//                             {
//                                 "Embedded": false,
//                                 "Name": "Name",
//                                 "Tag": "",
//                                 "Type": {
//                                     "@type": "/gno.PrimitiveType",
//                                     "value": "16"
//                                 }
//                             },
//                             {
//                                 "Embedded": false,
//                                 "Name": "Age",
//                                 "Tag": "",
//                                 "Type": {
//                                     "@type": "/gno.PrimitiveType",
//                                     "value": "32"
//                                 }
//                             },
//                             {
//                                 "Embedded": false,
//                                 "Name": "foo",
//                                 "Tag": "",
//                                 "Type": {
//                                     "@type": "/gno.RefType",
//                                     "ID": "gno.land/r/ptr_map.Foo"
//                                 }
//                             }
//                         ],
//                         "PkgPath": "gno.land/r/ptr_map"
//                     },
//                     "Methods": [],
//                     "Name": "MyStruct",
//                     "PkgPath": "gno.land/r/ptr_map"
//                 }
//             }
//         },
//         {
//             "Path": "",
//             "T": {
//                 "@type": "/gno.MapType",
//                 "Key": {
//                     "@type": "/gno.RefType",
//                     "ID": "gno.land/r/ptr_map.MyStruct"
//                 },
//                 "Value": {
//                     "@type": "/gno.PrimitiveType",
//                     "value": "16"
//                 }
//             },
//             "V": {
//                 "@type": "/gno.RefValue",
//                 "Hash": "51f396232e5af1041407c5423cf9ee0323ff8568",
//                 "ObjectID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:3"
//             }
//         },
//         {
//             "Path": "",
//             "T": {
//                 "@type": "/gno.RefType",
//                 "ID": "gno.land/r/ptr_map.Foo"
//             },
//             "V": {
//                 "@type": "/gno.RefValue",
//                 "Hash": "412def1fb599bd01b38e0d3ade81f3fd70c7b069",
//                 "ObjectID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:8"
//             }
//         },
//         {
//             "Path": "",
//             "T": {
//                 "@type": "/gno.FuncType",
//                 "Params": [],
//                 "Results": []
//             },
//             "V": {
//                 "@type": "/gno.FuncValue",
//                 "Closure": {
//                     "@type": "/gno.RefValue",
//                     "Escaped": true,
//                     "ObjectID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:5"
//                 },
//                 "FileName": "main.gno",
//                 "IsMethod": false,
//                 "Name": "init.4",
//                 "NativeName": "",
//                 "NativePkg": "",
//                 "PkgPath": "gno.land/r/ptr_map",
//                 "Source": {
//                     "@type": "/gno.RefNode",
//                     "BlockNode": null,
//                     "Location": {
//                         "Column": "1",
//                         "File": "main.gno",
//                         "Line": "17",
//                         "PkgPath": "gno.land/r/ptr_map"
//                     }
//                 },
//                 "Type": {
//                     "@type": "/gno.FuncType",
//                     "Params": [],
//                     "Results": []
//                 }
//             }
//         },
//         {
//             "Path": "",
//             "T": {
//                 "@type": "/gno.FuncType",
//                 "Params": [],
//                 "Results": []
//             },
//             "V": {
//                 "@type": "/gno.FuncValue",
//                 "Closure": {
//                     "@type": "/gno.RefValue",
//                     "Escaped": true,
//                     "ObjectID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:5"
//                 },
//                 "FileName": "main.gno",
//                 "IsMethod": false,
//                 "Name": "main",
//                 "NativeName": "",
//                 "NativePkg": "",
//                 "PkgPath": "gno.land/r/ptr_map",
//                 "Source": {
//                     "@type": "/gno.RefNode",
//                     "BlockNode": null,
//                     "Location": {
//                         "Column": "1",
//                         "File": "main.gno",
//                         "Line": "24",
//                         "PkgPath": "gno.land/r/ptr_map"
//                     }
//                 },
//                 "Type": {
//                     "@type": "/gno.FuncType",
//                     "Params": [],
//                     "Results": []
//                 }
//             }
//         }
//     ]
// }
// d[15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:6]
// d[15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:7]
