package governor

import 	"gno.land/p/grc/grc20extension"

type GovernorSettings struct {
	_votingDelay       int64
	_votingPeriod      int64
	_proposalThreshold int64
}

func NewGovernorSettings(votingDelay int64, votingPeriod int64, proposalThreshold int64) *GovernorSettings {
	return &GovernorSettings{
		_votingDelay:       votingDelay,
		_votingPeriod:      votingPeriod,
		_proposalThreshold: proposalThreshold,
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

// See {IGovernor-votingDelay}.
func (gs *GovernorSettings) votingDelay() int64 {
	return gs._votingDelay
}

// See {IGovernor-votingPeriod}.
func (gs *GovernorSettings) votingPeriod() int64 {
	return gs._votingPeriod
}

// See {Governor-proposalThreshold}.
func (gs *GovernorSettings) proposalThreshold() int64 {
	return gs._proposalThreshold
}

// Update the voting delay. This operation can only be performed through a governance proposal.
// Emits a {VotingDelaySet} event.

//todo check only governance modifier
func (gs *GovernorSettings) setVotingDelay(newVotingDelay int64) {
	// _setVotingDelay(newVotingDelay);
	gs._votingDelay = newVotingDelay
}

// Update the voting period. This operation can only be performed through a governance proposal.
// Emits a {VotingPeriodSet} event.

//modifier
func (gs *GovernorSettings) setVotingPeriod(newVotingPeriod int64) {
	// _setVotingPeriod(newVotingPeriod);

	// voting period must be at least one block long
	if newVotingPeriod <= 0 {
		panic("GovernorSettings: voting period too low")
	}
	// emit VotingPeriodSet(_votingPeriod, newVotingPeriod);
	gs._votingPeriod = newVotingPeriod
}

/**
// Update the proposal threshold. This operation can only be performed through a governance proposal.
// Emits a {ProposalThresholdSet} event.

//modifier
func (gs *GovernorSettings) setProposalThreshold(newProposalThreshold int64){
	// _setProposalThreshold(newProposalThreshold);
	gs._proposalThreshold = newProposalThreshold;
}

// /**
//  * @dev Internal setter for the voting delay.
//  *
//  * Emits a {VotingDelaySet} event.
//  */
// func _setVotingDelay(newVotingDelay int64) {
// 	// emit VotingDelaySet(_votingDelay, newVotingDelay);
// 	_votingDelay = newVotingDelay;
// }

// /**
//  * @dev Internal setter for the voting period.
//  *
//  * Emits a {VotingPeriodSet} event.
//  */
// func _setVotingPeriod(newVotingPeriod int64){
// 	// voting period must be at least one block long
// 	if(newVotingPeriod <=0){
// 		panic("GovernorSettings: voting period too low"))
// 	}
// 	// emit VotingPeriodSet(_votingPeriod, newVotingPeriod);
// 	_votingPeriod = newVotingPeriod;
// }

// /**
//  * @dev Internal setter for the proposal threshold.
//  *
//  * Emits a {ProposalThresholdSet} event.
//  */
// func _setProposalThreshold(newProposalThreshold int64) {
// 	// emit ProposalThresholdSet(_proposalThreshold, newProposalThreshold);
// 	_proposalThreshold = newProposalThreshold;
// }
