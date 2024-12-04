// PKGPATH: gno.land/r/ptr_map
package ptr_map

type MyStruct struct {
	Name string
	Age  int
}

var m = make(map[MyStruct]string)

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
//             "Path": "",
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
//             "Path": "",
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
// u[15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:2]={
//     "Blank": {
//         "Path": ""
//     },
//     "ObjectInfo": {
//         "ID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:2",
//         "IsEscaped": true,
//         "ModTime": "5",
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
//                 "Hash": "ea82cce4290f39cd9dc4e06ec49684469ba0fe36",
//                 "ObjectID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:3"
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
//                     "ObjectID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:4"
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
//                         "Line": "11",
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
