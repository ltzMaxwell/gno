package checkpoints

import (
	"std"
	"strconv"
)

type Checkpoint struct {
	blockNumber int64
	value       uint64
}

type History struct {
	checkpoints []Checkpoint
}

func NewHistory() *History {
	return &History{}
}

// Returns the value in the latest checkpoint, or zero if there are no checkpoints.
func (history *History) Latest() uint64 {
	pos := len(history.checkpoints)
	if pos == 0 {
		return 0
	} else {
		return history.checkpoints[pos-1].value
	}
}

// Returns the value at a given block number. If a checkpoint is not available at that block, the closest one
// before it is returned, or zero otherwise.
func (history *History) GetAtBlock(blockNumber int64) uint64 {
	height := std.GetHeight()
	if blockNumber >= height {
		panic("Checkpoints: block not yet mined:" + strconv.FormatInt(blockNumber, 10) + ":" + strconv.FormatInt(height, 10))
	}
	var high int64
	var low int64

	high = int64(len(history.checkpoints))
	low = 0
	for low < high {
		mid := _average(low, high)
		if history.checkpoints[mid].blockNumber > blockNumber {
			high = mid
		} else {
			low = mid + 1
		}
	}
	if high == 0 {
		return 0
	}
	return history.checkpoints[high-1].value
}

// (a + b) / 2 can overflow.
func _average(a, b int64) int64 {
	return (a & b) + (a^b)/2
}

// Pushes a value onto a History so that it is stored as the checkpoint for the current block.
// Returns previous value and new value.
func (history *History) Push(value uint64) (uint64, uint64) {
	pos := len(history.checkpoints)
	old := history.Latest()
	height := std.GetHeight()
	// same block, update
	if pos > 0 && history.checkpoints[pos-1].blockNumber == height {
		history.checkpoints[pos-1].value = value
	} else {
		history.checkpoints = append(history.checkpoints, Checkpoint{blockNumber: height, value: value})
	}
	return old, value
}

// Pushes a value onto a History, by updating the latest value using binary operation `op`. The new value will
// be set to `op(latest, delta)`.
// Returns previous value and new value.
func (history *History) PushWithOp(op func(uint64, uint64) uint64, delta uint64) (uint64, uint64) {
	return history.Push(op(history.Latest(), delta))
}
