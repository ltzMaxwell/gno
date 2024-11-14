// PKGPATH: gno.land/r/crossrealm_test
package crossrealm_test

var (
	m = map[**int]int{}
	i = new(int)
)

func AddToMap(value int) {
	m[&i] = value
}

func GetFromMap() int {
	return m[&i]
}

func init() {
	*i = 1
	AddToMap(5)
}

func main() {
	r := GetFromMap()
	println(r)
	println(r == 5)
	var j = 0
	j1 := &j
	println(m[&j1])
}

// Output:
// 5
// true
// 0
