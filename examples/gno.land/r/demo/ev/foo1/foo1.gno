package foo1

import "gno.land/r/demo/events"

func StartListening() {
	events.Evsw.AddListener("foo1", "bar", func(ev events.Event) {
		if s, ok := ev.(string); ok {
			println("foo1 got callback")
			println(s)
		} else {
			println("invalid callback")
		}
	})
}
