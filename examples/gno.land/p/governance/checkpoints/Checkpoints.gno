package checkpoints

import "std"

type Checkpoint struct {
	_blockNumber uint64
	_value       uint64
}

type History struct {
	_checkpoints []Checkpoint
}

func NewHistory() *History {
	return &History{}
}

// Returns the value in the latest checkpoint, or zero if there are no checkpoints.
func (history *History) Latest() uint64 {
	pos := len(history._checkpoints)
	if pos == 0 {
		return 0
	} else {
		return history._checkpoints[pos-1]._value
	}
}

// Returns the value at a given block number. If a checkpoint is not available at that block, the closest one
// before it is returned, or zero otherwise.
func (history *History) GetAtBlock(blockNumber uint64) uint64 {
	// require(blockNumber < block.number, "Checkpoints: block not yet mined");
	//todo how to get block.number
	//todo
	var high uint64
	var low uint64

	high = uint64(len(history._checkpoints))
	low = 0
	for low < high {
		mid := _average(low, high)
		if history._checkpoints[mid]._blockNumber > blockNumber {
			high = mid
		} else {
			low = mid + 1
		}
	}
	if high == 0 {
		return 0
	}
	return history._checkpoints[high-1]._value
}

// (a + b) / 2 can overflow.
func _average(a, b uint64) uint64 {
	return (a & b) + (a^b)/2
}

// Pushes a value onto a History so that it is stored as the checkpoint for the current block.
// Returns previous value and new value.
func (history *History) Push(value uint64) (uint64, uint64) {
	pos := len(history._checkpoints)
	old := history.Latest()
	height := uint64(std.GetHeight())
	if pos > 0 && history._checkpoints[pos-1]._blockNumber == height {
		history._checkpoints[pos-1]._value = value
	} else {
		history._checkpoints = append(history._checkpoints, Checkpoint{_blockNumber: height, _value: value})
	}
	return old, value
}

// Pushes a value onto a History, by updating the latest value using binary operation `op`. The new value will
// be set to `op(latest, delta)`.
// Returns previous value and new value.

func (history *History) PushWithOp(op func(uint64, uint64) uint64, delta uint64) (uint64, uint64) {
	return history.Push(op(history.Latest(), delta))
}
