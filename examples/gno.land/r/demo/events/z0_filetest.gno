package main

import (
	"gno.land/r/demo/events"
)

func main() {
	events.Evsw.AddListener("listener", func(ev events.Event) {
		// numbers <- uint64(ev.(Uint64Event))
		println("call back...")
	})
}

// Output:
