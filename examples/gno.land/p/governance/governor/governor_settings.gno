package governor

type GovernorSettings struct {
	_votingDelay       uint64
	_votingPeriod      uint64
	_proposalThreshold uint64
}

func NewGovernorSettings(votingDelay uint64, votingPeriod uint64, proposalThreshold uint64) *GovernorSettings {
	return &GovernorSettings{
		_votingDelay:       votingDelay,
		_votingPeriod:      votingPeriod,
		_proposalThreshold: proposalThreshold,
	}
}

type VotingDelaySetEvent struct {
	oldVotingDelay uint64
	newVotingDelay uint64
}

type VotingPeriodSetEvent struct {
	oldVotingPeriod uint64
	newVotingPeriod uint64
}

type ProposalThresholdSetEvent struct {
	oldProposalThreshold uint64
	newProposalThreshold uint64
}

// See {IGovernor-votingDelay}.
func (gs *GovernorSettings) votingDelay() uint64 {
	return gs._votingDelay
}

// See {IGovernor-votingPeriod}.
func (gs *GovernorSettings) votingPeriod() uint64 {
	return gs._votingPeriod
}

// See {Governor-proposalThreshold}.
func (gs *GovernorSettings) proposalThreshold() uint64 {
	return gs._proposalThreshold
}

// Update the voting delay. This operation can only be performed through a governance proposal.
// Emits a {VotingDelaySet} event.

//todo check only governance modifier
func (gs *GovernorSettings) setVotingDelay(newVotingDelay uint64) {
	// _setVotingDelay(newVotingDelay);
	gs._votingDelay = newVotingDelay
}

// Update the voting period. This operation can only be performed through a governance proposal.
// Emits a {VotingPeriodSet} event.

//modifier
func (gs *GovernorSettings) setVotingPeriod(newVotingPeriod uint64) {
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
func (gs *GovernorSettings) setProposalThreshold(newProposalThreshold uint64){
	// _setProposalThreshold(newProposalThreshold);
	gs._proposalThreshold = newProposalThreshold;
}

// /**
//  * @dev Internal setter for the voting delay.
//  *
//  * Emits a {VotingDelaySet} event.
//  */
// func _setVotingDelay(newVotingDelay uint64) {
// 	// emit VotingDelaySet(_votingDelay, newVotingDelay);
// 	_votingDelay = newVotingDelay;
// }

// /**
//  * @dev Internal setter for the voting period.
//  *
//  * Emits a {VotingPeriodSet} event.
//  */
// func _setVotingPeriod(newVotingPeriod uint64){
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
// func _setProposalThreshold(newProposalThreshold uint64) {
// 	// emit ProposalThresholdSet(_proposalThreshold, newProposalThreshold);
// 	_proposalThreshold = newProposalThreshold;
// }
