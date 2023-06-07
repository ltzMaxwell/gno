// Package events - Pub-Sub in go with event caching
package events

import "fmt"

var Evsw EventSwitch

func init() {
	Evsw = NewEventSwitch()
}

// All implementors must be amino-encodable.
type Event interface{}

// Eventable is the interface reactors and other modules must export to become
// eventable.
type Eventable interface {
	SetEventSwitch(evsw EventSwitch)
}

type Fireable interface {
	FireEvent(ev Event, emitterID string)
}

type Listenable interface {
	// Multiple callbacks can be registered for a given listenerID.  Events are
	// called back in the order that they were registered with this function.
	AddListener(listenerID string, emitterID string, cb EventCallback)
	// Removes all callbacks that match listenerID.
	RemoveListener(listenerID string)
}

// EventSwitch is the interface for synchronous pubsub, where listeners
// subscribe to certain events and, when an event is fired (see Fireable),
// notified via a callback function.
// All listeners are expected to perform work quickly and not block processing
// of the main event emitter.
type EventSwitch interface {
	Fireable
	Listenable
	String() string
}

type EventCallback func(event Event)

type listenCell struct {
	listenerID string
	cb         EventCallback
}

// This simple implementation is optimized for few listeners.
// This is faster for few listeners, especially for FireEvent.
type eventSwitch struct {
	listeners map[string][]listenCell
}

func NilEventSwitch() EventSwitch {
	return (*eventSwitch)(nil)
}

func NewEventSwitch() EventSwitch {
	evsw := &eventSwitch{
		listeners: make(map[string][]listenCell),
	}
	return evsw
}

func (evsw *eventSwitch) AddListener(listenerID string, emitterID string, cb EventCallback) {
	// println("add listerner")
	// println("emitterID: ", emitterID)
	// println("listenerID: ", listenerID)
	cells := evsw.listeners[emitterID]
	// println("len of cells before append: ", len(cells))
	cells = append(cells, listenCell{listenerID, cb})
	// println("len of cells after append: ", len(cells))
	evsw.listeners[emitterID] = cells
}

func (evsw *eventSwitch) RemoveListener(listenerID string) {
	// newlisteners := make([]listenCell, 0, len(evsw.listeners))
	// for _, cell := range evsw.listeners {
	// 	if cell.listenerID != listenerID {
	// 		newlisteners = append(newlisteners, cell)
	// 	}
	// }
	// evsw.listeners = newlisteners
}

// FireEvent on a nil switch is a noop, but no other operations are allowed for
// safety.
func (evsw *eventSwitch) FireEvent(event Event, emitterID string) {
	// println("fire event")
	// println("listeners: ", len(evsw.listeners[emitterID]))
	if evsw == nil {
		return
	}
	listeners := make([]listenCell, len(evsw.listeners[emitterID]))
	copy(listeners, evsw.listeners[emitterID])

	// println("len of cells: ", len(listeners))
	for _, cell := range listeners {
		// println("fire event...")
		cell.cb(event)
	}
}

func (evsw *eventSwitch) String() string {
	if evsw == nil {
		return "nil-eventSwitch"
	} else {
		for k, listeners := range evsw.listeners {
			println("emitterID: ", k)
			for _, l := range listeners {
				println(l.listenerID)
			}
			return fmt.Sprintf("*eventSwitch{%v}", len(listeners))
		}
	}
}
