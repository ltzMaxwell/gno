package main

import "gno.land/r/demo/ev/bar"
import "gno.land/r/demo/ev/foo"
import "gno.land/r/demo/ev/foo1"
import "gno.land/r/demo/events"

func main() {
	foo.StartListening()
	foo1.StartListening()

	println(events.Evsw.String())

	bar.Fire()
}

// Output:
// emitterID:  bar
// foo
// foo1
// *eventSwitch{2}
// foo got callback
// hey
// foo1 got callback
// hey
