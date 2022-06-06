package counters

type Counter struct{
	_value uint64
}

func (counter *Counter) Current() uint64 {
	return counter._value
}

func (counter *Counter) Increment(){
		counter._value += 1
}

func (counter *Counter) Decrement() {
	value := counter._value;
	if value <= 0{
		panic("Counter: decrement overflow")
		counter._value = value - 1
	}
}

func (counter *Counter) Reset() {
	counter._value = 0
}