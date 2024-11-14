// PKGPATH: gno.land/r/crossrealm_test
package crossrealm_test

var (
	li = []*int{}
	i  = new(int)
)

func init() {
	li = append(li, i)
}

func main() {
	println(li[0] == i)
}

// Output:
// true
