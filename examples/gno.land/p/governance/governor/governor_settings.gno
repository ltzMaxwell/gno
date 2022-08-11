package governor

import 	"gno.land/p/grc/grc20extension"

type GovernorSettings struct {
	votingDelay       int64
	votingPeriod      int64
	proposalThreshold int64
}

func NewGovernorSettings(votingDelay int64, votingPeriod int64, proposalThreshold int64) *GovernorSettings {
	return &GovernorSettings{
		votingDelay:       votingDelay,
		votingPeriod:      votingPeriod,
		proposalThreshold: proposalThreshold,
	}
}

type VotingDelaySetEvent struct {
	oldVotingDelay int64
	newVotingDelay int64
}

type VotingPeriodSetEvent struct {
	oldVotingPeriod int64
	newVotingPeriod int64
}

type ProposalThresholdSetEvent struct {
	oldProposalThreshold int64
	newProposalThreshold int64
}

func (gs *GovernorSettings) getVotingDelay() int64 {
	return gs.votingDelay
}

func (gs *GovernorSettings) getVotingPeriod() int64 {
	return gs.votingPeriod
}

func (gs *GovernorSettings) getProposalThreshold() int64 {
	return gs.proposalThreshold
}

// Update the voting delay. This operation can only be performed through a governance proposal.
// TODO: only governance
func (gs *GovernorSettings) setVotingDelay(newVotingDelay int64) {
	gs.votingDelay = newVotingDelay
}

// Update the voting period. This operation can only be performed through a governance proposal.
// TODO: only governance
func (gs *GovernorSettings) setVotingPeriod(newVotingPeriod int64) {
	// voting period must be at least one block long
	if newVotingPeriod <= 0 {
		panic("GovernorSettings: voting period too low")
	}
	// TODO: emit VotingPeriodSetEvent
	gs.votingPeriod = newVotingPeriod
}

// Update the proposal threshold. This operation can only be performed through a governance proposal.
// TODO: only governance
func (gs *GovernorSettings) setProposalThreshold(newProposalThreshold int64) {
	gs.proposalThreshold = newProposalThreshold
	// TODO: emit ProposalThresholdSetEvent
}