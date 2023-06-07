package foo

import "gno.land/r/demo/events"

func StartListening() {
	events.Evsw.AddListener("foo", "bar", func(ev events.Event) {
		if s, ok := ev.(string); ok {
			println("foo got callback")
			println(s)
		} else {
			println("invalid callback")
		}
	})
}
