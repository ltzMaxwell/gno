package governor

import 	"gno.land/p/grc/grc20extension"

type GovernorVotesQuorumFraction struct {
	_quorumNumerator uint64
	// gvrv *GovernorVotes
	_g20v *grc20votes.Grc20Votes
}

// Initialize quorum as a fraction of the token's total supply.
// The fraction is specified as `numerator / denominator`. By default the denominator is 100, so quorum is
// specified as a percent: a numerator of 10 corresponds to quorum being 10% of total supply. The denominator can be
// customized by overriding {quorumDenominator}.
func NewGovernorVotesQuorumFraction(_quorumNumerator uint64, g20v *grc20votes.Grc20Votes) *GovernorVotesQuorumFraction {
	return &GovernorVotesQuorumFraction{
		_quorumNumerator: _quorumNumerator,
		// gvrv: &GovernorVotes{},
		_g20v: g20v,
	}
}

type QuorumNumeratorUpdatedEvent struct {
	oldQuorumNumerator uint64
	newQuorumNumerator uint64
}

// Returns the current quorum numerator. See {quorumDenominator}.
func (gvqf *GovernorVotesQuorumFraction) quorumNumerator() uint64 {
	return gvqf._quorumNumerator
}

// Returns the quorum denominator. Defaults to 100, but may be overridden.
func (gvqf *GovernorVotesQuorumFraction) quorumDenominator() uint64 {
	return 100
}

// Returns the quorum for a block number, in terms of number of votes: `supply * numerator / denominator`.
func (gvqf *GovernorVotesQuorumFraction) quorum(blockNumber int64) uint64 {
	return (gvqf._g20v.GetPastTotalSupply(blockNumber) * gvqf.quorumNumerator()) / gvqf.quorumDenominator()
}

// Changes the quorum numerator.

// Emits a {QuorumNumeratorUpdated} event.

// Requirements:

// - Must be called through a governance proposal.
// - New numerator must be smaller or equal to the denominator.
func (gvqf *GovernorVotesQuorumFraction) updateQuorumNumerator(newQuorumNumerator uint64) {

	if newQuorumNumerator > gvqf.quorumDenominator() {
		panic("GovernorVotesQuorumFraction: quorumNumerator over quorumDenominator")
	}
	oldQuorumNumerator := gvqf._quorumNumerator
	gvqf._quorumNumerator = newQuorumNumerator

	// emit QuorumNumeratorUpdated(oldQuorumNumerator, newQuorumNumerator);
}
