package main

import (
	"gno.land/r/demo/events"
)

type Uint64Event uint64

func (Uint64Event) AssertEvent() {}

func main() {
	events.Evsw.FireEvent(Uint64Event(1))
}
