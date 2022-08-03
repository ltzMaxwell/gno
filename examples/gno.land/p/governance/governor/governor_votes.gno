package governor

import "std"

type GovernorVotes struct {
	//todo shoud be grc20Vote
	_g20v *grc20votes.Grc20Votes
}

func NewGovernorVotes(g20v *grc20votes.Grc20Votes) *GovernorVotes {
	return &GovernorVotes{
		_g20v: g20v,
	}
}

// Read the voting weight from the token's built in snapshot mechanism (see {Governor-_getVotes}).
func (gvrv *GovernorVotes) _getVotes(account std.Address, blockNumber uint64, params []byte) uint64 {
	return gvrv._g20v.GetPastVotes(account, blockNumber)
}
