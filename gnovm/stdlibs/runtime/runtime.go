package runtime

import gno "github.com/gnolang/gno/gnovm/pkg/gnolang"

func GC(m *gno.Machine) {
	m.Alloc.GC()
}

func MemStats(m *gno.Machine) string {
	return m.Alloc.MemStats()
}
