// PKGPATH: gno.land/r/ptr_map
package ptr_map

import "fmt"

type MyStruct struct {
	Name string
}

var (
	m = map[*[1]*MyStruct]string{}

	i1 = &MyStruct{Name: "alice"}
	i2 = &MyStruct{Name: "bob"}
)

func main() {
	// Create an array of pointers to MyStruct
	key1 := [1]*MyStruct{i1}
	key2 := [1]*MyStruct{i2}

	// Add entries to the map using arrays of pointers as keys
	m[&key1] = "first key"
	m[&key2] = "second key"

	// Access the value by key
	fmt.Println("Value for key1:", m[&key1])
	fmt.Println("Value for key2:", m[&key2])

	i1.Name = "Clark"
	fmt.Println("Value for key1:", m[&key1])
}

// Output:
// Value for key1: first key
// Value for key2: second key
// Value for key1: first key

// Realm:
// switchrealm["gno.land/r/ptr_map"]
// c[15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:10]={
//     "Data": null,
//     "List": [
//         {
//             "Path": "VPBlock(3,2)",
//             "T": {
//                 "@type": "/gno.PointerType",
//                 "Elt": {
//                     "@type": "/gno.RefType",
//                     "ID": "gno.land/r/ptr_map.MyStruct"
//                 }
//             },
//             "V": {
//                 "@type": "/gno.PointerValue",
//                 "Base": {
//                     "@type": "/gno.RefValue",
//                     "Escaped": true,
//                     "ObjectID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:4"
//                 },
//                 "Index": "0",
//                 "TV": null
//             }
//         }
//     ],
//     "ObjectInfo": {
//         "ID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:10",
//         "ModTime": "0",
//         "OwnerID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:9",
//         "RefCount": "1"
//     }
// }
// c[15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:11]={
//     "Data": null,
//     "List": [
//         {
//             "Path": "VPBlock(3,3)",
//             "T": {
//                 "@type": "/gno.PointerType",
//                 "Elt": {
//                     "@type": "/gno.RefType",
//                     "ID": "gno.land/r/ptr_map.MyStruct"
//                 }
//             },
//             "V": {
//                 "@type": "/gno.PointerValue",
//                 "Base": {
//                     "@type": "/gno.RefValue",
//                     "Escaped": true,
//                     "ObjectID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:6"
//                 },
//                 "Index": "0",
//                 "TV": null
//             }
//         }
//     ],
//     "ObjectInfo": {
//         "ID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:11",
//         "ModTime": "0",
//         "OwnerID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:9",
//         "RefCount": "1"
//     }
// }
// c[15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:9]={
//     "Blank": {
//         "Path": ""
//     },
//     "ObjectInfo": {
//         "ID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:9",
//         "ModTime": "0",
//         "OwnerID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:3",
//         "RefCount": "1"
//     },
//     "Parent": {
//         "@type": "/gno.RefValue",
//         "Escaped": true,
//         "ObjectID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:8"
//     },
//     "Source": {
//         "@type": "/gno.RefNode",
//         "BlockNode": null,
//         "Location": {
//             "Column": "1",
//             "File": "main.gno",
//             "Line": "17",
//             "PkgPath": "gno.land/r/ptr_map"
//         }
//     },
//     "Values": [
//         {
//             "Path": "VPBlock(1,0)",
//             "T": {
//                 "@type": "/gno.ArrayType",
//                 "Elt": {
//                     "@type": "/gno.PointerType",
//                     "Elt": {
//                         "@type": "/gno.RefType",
//                         "ID": "gno.land/r/ptr_map.MyStruct"
//                     }
//                 },
//                 "Len": "1",
//                 "Vrd": false
//             },
//             "V": {
//                 "@type": "/gno.RefValue",
//                 "Hash": "9ad7d0c3572ade2dff38b651de9010e2d034e2ff",
//                 "ObjectID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:10"
//             }
//         },
//         {
//             "Path": "VPBlock(1,1)",
//             "T": {
//                 "@type": "/gno.ArrayType",
//                 "Elt": {
//                     "@type": "/gno.PointerType",
//                     "Elt": {
//                         "@type": "/gno.RefType",
//                         "ID": "gno.land/r/ptr_map.MyStruct"
//                     }
//                 },
//                 "Len": "1",
//                 "Vrd": false
//             },
//             "V": {
//                 "@type": "/gno.RefValue",
//                 "Hash": "7ad89e9cf5684127796e38448f698dc02b9e2342",
//                 "ObjectID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:11"
//             }
//         }
//     ]
// }
// u[15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:3]={
//     "List": {
//         "List": [
//             {
//                 "Key": {
//                     "Path": "VPBlock(1,0)",
//                     "T": {
//                         "@type": "/gno.PointerType",
//                         "Elt": {
//                             "@type": "/gno.ArrayType",
//                             "Elt": {
//                                 "@type": "/gno.PointerType",
//                                 "Elt": {
//                                     "@type": "/gno.RefType",
//                                     "ID": "gno.land/r/ptr_map.MyStruct"
//                                 }
//                             },
//                             "Len": "1",
//                             "Vrd": false
//                         }
//                     },
//                     "V": {
//                         "@type": "/gno.PointerValue",
//                         "Base": {
//                             "@type": "/gno.RefValue",
//                             "Hash": "7ba6c162f0227dab62501326cce5b7d5b82f2e1a",
//                             "ObjectID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:9"
//                         },
//                         "Index": "0",
//                         "TV": null
//                     }
//                 },
//                 "Value": {
//                     "Path": "",
//                     "T": {
//                         "@type": "/gno.PrimitiveType",
//                         "value": "16"
//                     },
//                     "V": {
//                         "@type": "/gno.StringValue",
//                         "value": "first key"
//                     }
//                 }
//             },
//             {
//                 "Key": {
//                     "Path": "VPBlock(1,1)",
//                     "T": {
//                         "@type": "/gno.PointerType",
//                         "Elt": {
//                             "@type": "/gno.ArrayType",
//                             "Elt": {
//                                 "@type": "/gno.PointerType",
//                                 "Elt": {
//                                     "@type": "/gno.RefType",
//                                     "ID": "gno.land/r/ptr_map.MyStruct"
//                                 }
//                             },
//                             "Len": "1",
//                             "Vrd": false
//                         }
//                     },
//                     "V": {
//                         "@type": "/gno.PointerValue",
//                         "Base": {
//                             "@type": "/gno.RefValue",
//                             "Hash": "7ba6c162f0227dab62501326cce5b7d5b82f2e1a",
//                             "ObjectID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:9"
//                         },
//                         "Index": "1",
//                         "TV": null
//                     }
//                 },
//                 "Value": {
//                     "Path": "",
//                     "T": {
//                         "@type": "/gno.PrimitiveType",
//                         "value": "16"
//                     },
//                     "V": {
//                         "@type": "/gno.StringValue",
//                         "value": "second key"
//                     }
//                 }
//             }
//         ]
//     },
//     "ObjectInfo": {
//         "ID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:3",
//         "ModTime": "8",
//         "OwnerID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:2",
//         "RefCount": "1"
//     }
// }
// u[15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:5]={
//     "Fields": [
//         {
//             "Path": "",
//             "T": {
//                 "@type": "/gno.PrimitiveType",
//                 "value": "16"
//             },
//             "V": {
//                 "@type": "/gno.StringValue",
//                 "value": "Clark"
//             }
//         }
//     ],
//     "ObjectInfo": {
//         "ID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:5",
//         "ModTime": "8",
//         "OwnerID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:4",
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
//         "ModTime": "11",
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
//                     "@type": "/gno.PointerType",
//                     "Elt": {
//                         "@type": "/gno.ArrayType",
//                         "Elt": {
//                             "@type": "/gno.PointerType",
//                             "Elt": {
//                                 "@type": "/gno.RefType",
//                                 "ID": "gno.land/r/ptr_map.MyStruct"
//                             }
//                         },
//                         "Len": "1",
//                         "Vrd": false
//                     }
//                 },
//                 "Value": {
//                     "@type": "/gno.PrimitiveType",
//                     "value": "16"
//                 }
//             },
//             "V": {
//                 "@type": "/gno.RefValue",
//                 "Hash": "b62ba9ddc8e9eb9b07315cc755cf8a86e41fbde9",
//                 "ObjectID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:3"
//             }
//         },
//         {
//             "Path": "",
//             "T": {
//                 "@type": "/gno.PointerType",
//                 "Elt": {
//                     "@type": "/gno.RefType",
//                     "ID": "gno.land/r/ptr_map.MyStruct"
//                 }
//             },
//             "V": {
//                 "@type": "/gno.PointerValue",
//                 "Base": {
//                     "@type": "/gno.RefValue",
//                     "Escaped": true,
//                     "ObjectID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:4"
//                 },
//                 "Index": "0",
//                 "TV": null
//             }
//         },
//         {
//             "Path": "",
//             "T": {
//                 "@type": "/gno.PointerType",
//                 "Elt": {
//                     "@type": "/gno.RefType",
//                     "ID": "gno.land/r/ptr_map.MyStruct"
//                 }
//             },
//             "V": {
//                 "@type": "/gno.PointerValue",
//                 "Base": {
//                     "@type": "/gno.RefValue",
//                     "Escaped": true,
//                     "ObjectID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:6"
//                 },
//                 "Index": "0",
//                 "TV": null
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
//                     "ObjectID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:8"
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
//         }
//     ]
// }
// u[15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:4]={
//     "ObjectInfo": {
//         "ID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:4",
//         "IsEscaped": true,
//         "ModTime": "11",
//         "RefCount": "2"
//     },
//     "Value": {
//         "Path": "",
//         "T": {
//             "@type": "/gno.RefType",
//             "ID": "gno.land/r/ptr_map.MyStruct"
//         },
//         "V": {
//             "@type": "/gno.RefValue",
//             "Hash": "65128fa4023807c3efb6c6274ef763f59647e28c",
//             "ObjectID": "15bc39c5756bbda67fd0d56bc9e86b29d7b444fc:5"
//         }
//     }
// }
