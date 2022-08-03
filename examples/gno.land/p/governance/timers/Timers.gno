package timers

import "std"

type Timestamp struct {
	_deadline uint64
}

func NewTimestamp() *Timestamp {
	return &Timestamp{
		_deadline: 0,
	}
}

func (timer *Timestamp) getDeadline() uint64 {
	return timer._deadline
}

func (timer *Timestamp) setDeadline(timestamp uint64) {
	timer._deadline = timestamp
}

func (timer *Timestamp) reset() {
	timer._deadline = 0
}

func (timer *Timestamp) isUnset() bool {
	return timer._deadline == 0
}

func (timer *Timestamp) isStarted() bool {
	return timer._deadline > 0
}

// func (timer. *Timestamp) isPending()bool{
// 	return timer._deadline > block.timestamp;
// }

// func (timer. *Timestamp) isExpired()bool{
// 	return timer.isStarted() && timer._deadline <= block.timestamp;
// }

type BlockNumber struct {
	_deadline uint64
}

func NewBlockNumber() *BlockNumber {
	return &BlockNumber{
		_deadline: 0,
	}
}

func (timer *BlockNumber) GetDeadline() uint64 {
	return timer._deadline
}

func (timer *BlockNumber) SetDeadline(timestamp uint64) {
	timer._deadline = timestamp
}

func (timer *BlockNumber) reset() {
	timer._deadline = 0
}

func (timer *BlockNumber) IsUnset() bool {
	return timer._deadline == 0
}

func (timer *BlockNumber) isStarted() bool {
	return timer._deadline > 0
}

func (timer *BlockNumber) isPending() bool {
	height := uint64(std.GetHeight())
	return timer._deadline > height
}

func (timer *BlockNumber) isExpired() bool {
	height := uint64(std.GetHeight())
	return timer.isStarted() && timer._deadline <= height
}
