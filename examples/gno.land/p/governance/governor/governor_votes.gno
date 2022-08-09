package governor

import "std"
import "gno.land/p/grc/grc20extension"

type GovernorVotes struct {
	grc20Vote *grc20votes.Grc20Votes
}

func NewGovernorVotes(g20v *grc20votes.Grc20Votes) *GovernorVotes {
	return &GovernorVotes{
		grc20Vote: g20v,
	}
}

// Read the voting weight from the token's built in snapshot mechanism (see {Governor-_getVotes}).
func (gvrv *GovernorVotes) getVotes(account std.Address, blockNumber int64, params []byte) uint64 {
	return gvrv.grc20Vote.GetPastVotes(account, blockNumber)
}
