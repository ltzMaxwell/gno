package bar

import "gno.land/r/demo/events"

func Fire() {
	events.Evsw.FireEvent("hey", "bar")
}
