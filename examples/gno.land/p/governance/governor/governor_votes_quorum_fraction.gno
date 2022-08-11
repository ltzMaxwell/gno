package governor

import 	"gno.land/p/grc/grc20extension"

type GovernorVotesQuorumFraction struct {
	quorumNumerator uint64
	g20v *grc20votes.Grc20Votes
}

// Initialize quorum as a fraction of the token's total supply.
// The fraction is specified as `numerator / denominator`. By default the denominator is 100, so quorum is
// specified as a percent: a numerator of 10 corresponds to quorum being 10% of total supply. 
func NewGovernorVotesQuorumFraction(quorumNumerator uint64, g20v *grc20votes.Grc20Votes) *GovernorVotesQuorumFraction {
	return &GovernorVotesQuorumFraction{
		quorumNumerator: quorumNumerator,
		g20v: g20v,
	}
}

type QuorumNumeratorUpdatedEvent struct {
	oldQuorumNumerator uint64
	newQuorumNumerator uint64
}

// Returns the current quorum numerator
func (gvqf *GovernorVotesQuorumFraction) getQuorumNumerator() uint64 {
	return gvqf.quorumNumerator
}

// Returns the quorum denominator. Defaults to 100.
func (gvqf *GovernorVotesQuorumFraction) getQuorumDenominator() uint64 {
	return 100
}

// Returns the quorum for a block number, in terms of number of votes: `supply * numerator / denominator`.
func (gvqf *GovernorVotesQuorumFraction) quorum(blockNumber int64) uint64 {
	return (gvqf.g20v.GetPastTotalSupply(blockNumber) * gvqf.getQuorumNumerator()) / gvqf.getQuorumDenominator()
}

// Changes the quorum numerator.
// Emits a QuorumNumeratorUpdatedEvent.

// Requirements:
// - Must be called through a governance proposal.
// - New numerator must be smaller or equal to the denominator.
func (gvqf *GovernorVotesQuorumFraction) updateQuorumNumerator(newQuorumNumerator uint64) {
	if newQuorumNumerator > gvqf.getQuorumDenominator() {
		panic("GovernorVotesQuorumFraction: quorumNumerator over quorumDenominator")
	}
	oldQuorumNumerator := gvqf.quorumNumerator
	gvqf.quorumNumerator = newQuorumNumerator
	// emit QuorumNumeratorUpdated(oldQuorumNumerator, newQuorumNumerator);
}