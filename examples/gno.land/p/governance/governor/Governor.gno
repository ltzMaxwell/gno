package governor

import (
	"std"
	"gno.land/p/avl"
	"gno.land/p/governance/timers"
	"gno.land/p/ufmt"
	"gno.land/p/grc/grc20extension"
)

type ProposalState int

const (
	Pending ProposalState = iota
	Active
	Canceled
	Defeated
	Succeeded
	Queued
	Expired
	Executed
)

func (ps ProposalState) String() string {
	switch ps {
	case Pending:
		return "Pending"
	case Active:
		return "Active"
	case Canceled:
		return "Canceled"
	case Defeated:
		return "Defeated"
	case Succeeded:
		return "Succeeded"
	case Queued:
		return "Queued"
	case Expired:
		return "Expired"
	case Executed:
		return "Executed"
	default:
		return ufmt.Sprintf("%d", int(ps))
	}
}

type ProposalCore struct {
	voteStart timers.BlockNumber
	voteEnd   timers.BlockNumber
	executed  bool
	canceled  bool
}

type Governor struct {
	name      string
	proposals *avl.MutTree // ProposalId => ProposalCore
	gcs       *GovernorCountingSimple
	gv        *GovernorVotes
	gs        *GovernorSettings
}

func NewGovernor(name string, g20v *grc20votes.Grc20Votes, votingDelay int64, votingPeriod int64, proposalThreshold int64) *Governor {
	return &Governor{
		name:      name,
		proposals: avl.NewMutTree(),
		gcs:       NewGovernorCountingSimple(g20v),
		gv:        NewGovernorVotes(g20v),
		gs:        NewGovernorSettings(votingDelay, votingPeriod, proposalThreshold),
	}
}

func (gvr *Governor) getName() string {
	return gvr.name
}

func (gvr *Governor) getVersion() string {
	return "1"
}

func hashProposal(targets []std.Address, values []uint64, calldatas []byte, descriptionHash []byte) string {
	// TODO: impl hash
	return "test"
}

func (gvr *Governor) state(proposalId string) ProposalState {
	proposalI, found := gvr.proposals.Get(proposalId)
	if !found {
		panic("Governor: proposal not exist!")
	}

	proposal := proposalI.(*ProposalCore)

	if proposal.executed {
		return Executed
	}

	if proposal.canceled {
		return Canceled
	}

	snapshot := gvr.proposalSnapshot(proposalId)

	if snapshot == 0 {
		panic("Governor: unknown proposalId")
	}

	height := std.GetHeight()

	if snapshot >= height {
		return Pending
	}

	deadline := gvr.proposalDeadline(proposalId)

	if deadline >= height {
		return Active
	}
	if gvr.gcs.quorumReached(proposalId, snapshot) && gvr.gcs.voteSucceeded(proposalId) {
		return Succeeded
	} else {
		return Defeated
	}
}

func (gvr *Governor) proposalSnapshot(proposalId string) int64 {
	proposalI, found := gvr.proposals.Get(proposalId)
	if !found {
		// TODO
		return 0
	}
	proposal := proposalI.(*ProposalCore)
	return proposal.voteStart.GetDeadline()
}

func (gvr *Governor) proposalDeadline(proposalId string) int64 {
	proposalI, found := gvr.proposals.Get(proposalId)
	if !found {
		// TODO:
		return 0
	}

	proposal := proposalI.(*ProposalCore)
	return proposal.voteEnd.GetDeadline()
}

// Part of the Governor Bravo's interface: _"The number of votes required in order for a voter to become a proposer"_.
func (gvr *Governor) proposalThreshold() uint64 {
	return 0
}

// Default additional encoded parameters used by castVote methods that don't include them
// Note: Should be overriden by specific implementations to use an appropriate value, the
// meaning of the additional params, in the context of that implementation
func defaultParams() []byte {
	return ""
}

// Returns weither `account` has cast a vote on `proposalId`.
// func hasVoted(proposalId uint64, account std.Address) bool{}

func (gvr *Governor) Propose(targets []std.Address, values []uint64, calldatas []byte, description string) string {
	sender := std.GetOrigCaller()
	height := std.GetHeight()
	if gvr.GetVotes(sender, height-1) < gvr.proposalThreshold() {
		panic("GovernorCompatibilityBravo: proposer votes below proposal threshold")
	}

	proposalId := hashProposal(targets, values, calldatas, []byte(description))

	if len(targets) != len(values) {
		panic("Governor: invalid proposal length")
	}
	if len(targets) != len(calldatas) {
		panic("Governor: invalid proposal length")
	}
	if len(targets) <= 0 {
		panic("Governor: empty proposal")
	}

	var proposal *ProposalCore
	proposalI, found := gvr.proposals.Get(proposalId)
	if !found {
		proposal = &ProposalCore{}
	} else {
		proposal = proposalI.(*ProposalCore)
	}

	if !proposal.voteStart.IsUnset() {
		panic("Governor: proposal already exists")
	}

	snapshot := std.GetHeight() + gvr.gs.getVotingDelay()
	deadline := snapshot + gvr.gs.getVotingPeriod()

	proposal.voteStart.SetDeadline(snapshot)
	proposal.voteEnd.SetDeadline(deadline)

	gvr.proposals.Set(proposalId, proposal)

	// TODO: emit ProposalCreatedEvent
	return proposalId
}

func (gvr *Governor) execute(targets []std.Address, values []uint64, calldatas []byte, description []byte) string {
	proposalId := hashProposal(targets, values, calldatas, description)

	status := gvr.state(proposalId)
	if status != Succeeded && status != Queued {
		panic("Governor: proposal not successful")
	}
	proposalI, exists := gvr.proposals.Get(proposalId)
	if !exists {
		panic("Governor: proposal not exist")
	}

	proposal := proposalI.(*ProposalCore)

	proposal.executed = true
	gvr.proposals.Set(proposalId, proposal)

	// TODO: emit ProposalExecuted(proposalId);

	// _beforeExecute(proposalId, targets, values, calldatas, descriptionHash)
	_execute(proposalId, targets, values, calldatas, description)
	// _afterExecute(proposalId, targets, values, calldatas, descriptionHash)

	return proposalId
}

// Internal execution mechanism. Can be overriden to implement different execution mechanism
func _execute(proposalId string, targets []std.Address, values []uint64, calldatas []byte, description []byte) {
	println("proposal executed")
	// TODO: implement real execute logic
	// errorMessage := "Governor: call reverted without message"
	// for (i := 0; i < targets.length; i++) {
	// }
}

// Hook before execution is trigerred.
// func _beforeExecute(proposalId uint64, targets []std.Address, values []uint64, calldatas []byte, description []byte){
	// TODO: impl real hook
// }

// Hook after execution is trigerred.
// func _afterExecute(proposalId uint64, targets []std.Address, values []uint64, calldatas []byte, description []byte){
	// TODO: impl real hook
// }

// Internal cancel mechanism: locks up the proposal timer, preventing it from being re-submitted. Marks it as
// canceled to allow distinguishing it from executed proposals.
func (gvr *Governor) cancel(targets []std.Address, values []uint64, calldatas []byte, description []byte) string {
	// TODO: descriptionHash?
	proposalId := hashProposal(targets, values, calldatas, description)
	status := gvr.state(proposalId)

	if !(status != Canceled && status != Expired && status != Executed) {
		panic("Governor: proposal not active")
	}
	proposalI, exists := gvr.proposals.Get(proposalId)
	if !exists {
		panic("Governor: proposal not exist")
	}
	proposal := proposalI.(*ProposalCore)
	proposal.canceled = true
	gvr.proposals.Set(proposalId, proposal)

	// TODO: emit ProposalCanceled(proposalId);
	return proposalId
}

func (gvr *Governor) GetVotes(account std.Address, blockNumber int64) uint64 {
	return gvr.gv.getVotes(account, blockNumber, defaultParams())
}

func (gvr *Governor) getVotesWithParams(account std.Address, blockNumber int64, params []byte) uint64 {
	return gvr.gv.getVotes(account, blockNumber, params)
}

func (gvr *Governor) CastVote(proposalId string, support uint8) uint64 {
	voter := std.GetOrigCaller()
	return gvr.castVote(proposalId, voter, support, "")
}

func (gvr *Governor) CastVoteWithReason(proposalId string, support uint8, reason string) uint64 {
	voter := std.GetOrigCaller()
	return gvr.castVote(proposalId, voter, support, reason)
}

func (gvr *Governor) CastVoteWithReasonAndParams(proposalId string, support uint8, reason string, params []byte) uint64 {
	voter := std.GetOrigCaller()
	return gvr.castVoteWithReasonParams(proposalId, voter, support, reason, params)
}

// Internal vote casting mechanism: Check that the vote is pending, that it has not been cast yet, retrieve
// voting weight using {IGovernor-getVotes} and call the {_countVote} internal function. Uses the defaultParams().
func (gvr *Governor) castVote(proposalId string, account std.Address, support uint8, reason string) uint64 {
	return gvr.castVoteWithReasonParams(proposalId, account, support, reason, defaultParams())
}

// Internal vote casting mechanism: Check that the vote is pending, that it has not been cast yet, retrieve
// voting weight using {IGovernor-getVotes} and call the {_countVote} internal function.
func (gvr *Governor) castVoteWithReasonParams(proposalId string, account std.Address, support uint8, reason string, params []byte) uint64 {
	proposalI, exists := gvr.proposals.Get(proposalId)
	if !exists {
		panic("Governor: proposal not exist")
	}

	proposal := proposalI.(*ProposalCore)

	if gvr.state(proposalId) != Active {
		panic("Governor: vote not currently active")
	}
	weight := gvr.gv.getVotes(account, proposal.voteStart.GetDeadline(), params)
	gvr.gcs.countVote(proposalId, account, support, weight, params)

	if len(params) == 0 {
		// TODO: emit VoteCastEvent
	} else {
		// TODO: emit VoteCastWithParamsEvent
	}
	return weight
}

// Relays a transaction or function call to an arbitrary target. In cases where the governance executor
// is some contract other than the governor itself, like when using a timelock, this function can be invoked
// in a governance proposal to recover tokens or Ether that was sent to the governor contract by mistake.
// Note that if the executor is simply the governor itself, use of `relay` is redundant.
func relay(target std.Address, value uint64, data []byte) {
	// TODO: only governance modifier
	// Address.functionCallWithValue(target, data, value);
}

// Address through which the governor executes action. Will be overloaded by module that execute actions
// through another contract such as a timelock.
func executor() std.Address {
	// TODO:
	// return address(this);
}

func (gvr *Governor) RenderHome(proposalId string) string {
	state := gvr.state(proposalId)
	snapShot := gvr.proposalSnapshot(proposalId)
	deadLine := gvr.proposalDeadline(proposalId)

	str := ""
	str += ufmt.Sprintf("***Proposal state is***: %s\n", state.String())
	str += ufmt.Sprintf("***Proposal snapShot is***: %d\n", snapShot)
	str += ufmt.Sprintf("***Proposal deadLine is***: %d\n", deadLine)
	return str
}
