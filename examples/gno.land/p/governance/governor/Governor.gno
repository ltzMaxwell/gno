package governor

import (
	"std"

	"gno.land/p/avl"
	"gno.land/p/governance/timers"
	"gno.land/p/ufmt"
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

func NewGovernor(g20v *grc20votes.Grc20Votes, votingDelay uint64, votingPeriod uint64, proposalThreshold uint64) *Governor {
	return &Governor{
		name:      "",
		proposals: avl.NewMutTree(),
		gcs:       NewGovernorCountingSimple(g20v),
		gv:        NewGovernorVotes(g20v),
		gs:        NewGovernorSettings(votingDelay, votingPeriod, proposalThreshold),
	}
}

// This queue keeps track of the governor operating on itself. Calls to functions protected by the
// {onlyGovernance} modifier needs to be whitelisted in this queue. Whitelisting is set in {_beforeExecute},
// consummed by the {onlyGovernance} modifier and eventually reset in {_afterExecute}. This ensures that the
// execution of {onlyGovernance} protected calls can only be achieved through successful proposals.
// DoubleEndedQueue.Bytes32Deque private _governanceCall;

/**
* @dev Restricts a function so it can only be executed through governance proposals. For example, governance
* parameter setters in {GovernorSettings} are protected using this modifier.
*
* The governance executing address may be different from the Governor's own address, for example it could be a
* timelock. This can be customized by modules by overriding {_executor}. The executor is only able to invoke these
* functions during the execution of the governor's {execute} function, and not under any other circumstances. Thus,
* for example, additional timelock proposers are not able to change governance parameters without going through the
* governance protocol (since v4.6).
 */

//should write a modifier style function
// func modifier_onlyGovernance() {
// 	require(_msgSender() == _executor(), "Governor: onlyGovernance");
// 		if (_executor() != address(this)) {
// 		bytes32 msgDataHash = keccak256(_msgData());
// 		// loop until poping the expected operation - throw if deque is empty (operation not authorized)
// 		while (_governanceCall.popFront() != msgDataHash) {}
// 	}
// }

// See {IGovernor-name}.

func (gvr *Governor) getName() string {
	return gvr.name
}

// See {IGovernor-version}.
func (gvr *Governor) getVersion() string {
	return "1"
}

func hashProposal(targets []std.Address, values []uint64, calldatas []byte, descriptionHash []byte) string {
	return "test"
}

// See {IGovernor-state}.
func (gvr *Governor) state(proposalId string) ProposalState {
	proposalI, found := gvr.proposals.Get(proposalId)
	if !found {
		//todo
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
		//how to do revert?
		// revert("Governor: unknown proposal id");
		panic("Governor: unknown proposalId")
	}

	//todo check conversion
	height := uint64(std.GetHeight())

	if snapshot >= height {
		return Pending
	}

	deadline := gvr.proposalDeadline(proposalId)

	if deadline >= height {
		return Active
	}
	if gvr.gcs._quorumReached(proposalId, snapshot) && gvr.gcs._voteSucceeded(proposalId) {
		return Succeeded
	} else {
		return Defeated
	}
}

// See {IGovernor-proposalSnapshot}.
func (gvr *Governor) proposalSnapshot(proposalId string) uint64 {
	proposalI, found := gvr.proposals.Get(proposalId)
	if !found {
		//todo
		return 0
	}
	proposal := proposalI.(*ProposalCore)
	return proposal.voteStart.GetDeadline()
}

// See {IGovernor-proposalDeadline}.
func (gvr *Governor) proposalDeadline(proposalId string) uint64 {
	proposalI, found := gvr.proposals.Get(proposalId)
	if !found {
		//todo
		return 0
	}

	proposal := proposalI.(*ProposalCore)
	return proposal.voteEnd.GetDeadline()
}

//Part of the Governor Bravo's interface: _"The number of votes required in order for a voter to become a proposer"_.
func (gvr *Governor) proposalThreshold() uint64 {
	return 0
}

/**
 * @dev Amount of votes already cast passes the threshold limit.
 */
// func _quorumReached(proposalId uint64) bool{}

/**
 * @dev Is the proposal successful or not.
 */
// func _voteSucceeded(proposalId uint64) bool{}

/**
 * @dev Get the voting weight of `account` at a specific `blockNumber`, for a vote as described by `params`.
 */
// func _getVotes(account std.Address, blockNumber uint64, params []byte)uint64{}

/**
 * @dev Register a vote with a given support and voting weight.
 *
 * Note: Support is generic and can represent various things depending on the voting system used.
 */
// func _countVote(proposalId uint64, account std.Address, support uint8 , weight uint64, params []byte) {}

/**
 * @dev Default additional encoded parameters used by castVote methods that don't include them
 *
 * Note: Should be overriden by specific implementations to use an appropriate value, the
 * meaning of the additional params, in the context of that implementation
 */
func _defaultParams() []byte {
	return ""
}

/**
 * @notice module:voting
 * @dev Returns weither `account` has cast a vote on `proposalId`.
 */
// func hasVoted(proposalId uint64, account std.Address) bool{}

// See {IGovernor-propose}.
func (gvr *Governor) Propose(targets []std.Address, values []uint64, calldatas []byte, description string) string {
	//get caller
	// sender := std.GetCallerAt(2)
	sender := std.GetOrigCaller()
	height := uint64(std.GetHeight())
	if gvr.GetVotes(sender, height-1) < gvr.proposalThreshold() {
		panic("GovernorCompatibilityBravo: proposer votes below proposal threshold")
	}

	//impl hash function
	// proposalId := hashProposal(targets, values, calldatas, keccak256(bytes(description)));
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

	snapshot := uint64(std.GetHeight()) + gvr.gs.votingDelay()
	deadline := snapshot + gvr.gs.votingPeriod()

	proposal.voteStart.SetDeadline(snapshot)
	proposal.voteEnd.SetDeadline(deadline)

	gvr.proposals.Set(proposalId, proposal)

	//todo
	// emit ProposalCreated(
	// 	proposalId,
	// 	_msgSender(),
	// 	targets,
	// 	values,
	// 	new string[](targets.length),
	// 	calldatas,
	// 	snapshot,
	// 	deadline,
	// 	description
	// )

	return proposalId
}

// See {IGovernor-execute}.
func (gvr *Governor) execute(targets []std.Address, values []uint64, calldatas []byte, description []byte) string {
	//todo hash function desc
	proposalId := hashProposal(targets, values, calldatas, description)

	status := gvr.state(proposalId)
	if status != Succeeded && status != Queued {
		panic("Governor: proposal not successful")
	}
	//get->update->set
	proposalI, exists := gvr.proposals.Get(proposalId)
	if !exists {
		panic("Governor: proposal not exist")
	}

	proposal := proposalI.(*ProposalCore)

	proposal.executed = true
	gvr.proposals.Set(proposalId, proposal)

	//emit
	// emit ProposalExecuted(proposalId);

	// _beforeExecute(proposalId, targets, values, calldatas, descriptionHash)
	// _execute(proposalId, targets, values, calldatas, descriptionHash)
	_execute(proposalId, targets, values, calldatas, description)
	// _afterExecute(proposalId, targets, values, calldatas, descriptionHash)

	return proposalId
}

// Internal execution mechanism. Can be overriden to implement different execution mechanism
func _execute(proposalId string, targets []std.Address, values []uint64, calldatas []byte, description []byte) {
	// errorMessage := "Governor: call reverted without message"
	// for (i := 0; i < targets.length; i++) {
	// 	//todo, impl calls from contract to contract
	// 	// success, returndata := targets[i].call{value: values[i]}(calldatas[i]);
	// 	// Address.verifyCallResult(success, returndata, errorMessage);
	// }
}

/**
 * @dev Hook before execution is trigerred.
 */
// func _beforeExecute(proposalId uint64, targets []std.Address, values []uint64, calldatas []byte, description []byte){
// 	//address(this)?
// 	if (_executor() != address(this)) {
// 		for (uint256 i = 0; i < targets.length; ++i) {
// 			if (targets[i] == address(this)) {
// 				//queue impl
// 				_governanceCall.pushBack(keccak256(calldatas[i]));
// 			}
// 		}
// 	}
// }

/**
 * @dev Hook after execution is trigerred.
 */
// func _afterExecute(proposalId uint64, targets []std.Address, values []uint64, calldatas []byte, description []byte){
// 	if (_executor() != address(this)) {
// 		if (!_governanceCall.empty()) {
// 			_governanceCall.clear();
// 		}
// 	}
// }

// Internal cancel mechanism: locks up the proposal timer, preventing it from being re-submitted. Marks it as
// canceled to allow distinguishing it from executed proposals.
// Emits a {IGovernor-ProposalCanceled} event.
func (gvr *Governor) _cancel(targets []std.Address, values []uint64, calldatas []byte, description []byte) string {
	//todo descriptionHash
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

	//todo
	// emit ProposalCanceled(proposalId);

	return proposalId
}

// See {IGovernor-getVotes}.
func (gvr *Governor) GetVotes(account std.Address, blockNumber uint64) uint64 {
	return gvr.gv._getVotes(account, blockNumber, _defaultParams())
}

// See {IGovernor-getVotesWithParams}.
func (gvr *Governor) getVotesWithParams(account std.Address, blockNumber uint64, params []byte) uint64 {
	return gvr.gv._getVotes(account, blockNumber, params)
}

/**
 * @dev See {IGovernor-castVote}.
 */
func (gvr *Governor) CastVote(proposalId string, support uint8) uint64 {
	//get caller
	voter := std.GetOrigCaller()
	return gvr._castVote(proposalId, voter, support, "")
}

// See {IGovernor-castVoteWithReason}.
func (gvr *Governor) CastVoteWithReason(proposalId string, support uint8, reason string) uint64 {
	//get caller
	voter := std.GetOrigCaller()
	return gvr._castVote(proposalId, voter, support, reason)
}

// See {IGovernor-castVoteWithReasonAndParams}.
func (gvr *Governor) CastVoteWithReasonAndParams(proposalId string, support uint8, reason string, params []byte) uint64 {
	voter := std.GetOrigCaller()
	return gvr._castVoteWithReasonParams(proposalId, voter, support, reason, params)
}

// Internal vote casting mechanism: Check that the vote is pending, that it has not been cast yet, retrieve
// voting weight using {IGovernor-getVotes} and call the {_countVote} internal function. Uses the _defaultParams().
// Emits a {IGovernor-VoteCast} event.
func (gvr *Governor) _castVote(proposalId string, account std.Address, support uint8, reason string) uint64 {
	return gvr._castVoteWithReasonParams(proposalId, account, support, reason, _defaultParams())
}

// Internal vote casting mechanism: Check that the vote is pending, that it has not been cast yet, retrieve
// voting weight using {IGovernor-getVotes} and call the {_countVote} internal function.
// Emits a {IGovernor-VoteCast} event.
func (gvr *Governor) _castVoteWithReasonParams(proposalId string, account std.Address, support uint8, reason string, params []byte) uint64 {
	proposalI, exists := gvr.proposals.Get(proposalId)
	if !exists {
		panic("Governor: proposal not exist")
	}

	proposal := proposalI.(*ProposalCore)

	if gvr.state(proposalId) != Active {
		panic("Governor: vote not currently active")
	}
	weight := gvr.gv._getVotes(account, proposal.voteStart.GetDeadline(), params)
	gvr.gcs._countVote(proposalId, account, support, weight, params)

	if len(params) == 0 {
		//todo
		// emit VoteCast(account, proposalId, support, weight, reason);
	} else {
		//todo
		// emit VoteCastWithParams(account, proposalId, support, weight, reason,params);
	}
	return weight
}

// Relays a transaction or function call to an arbitrary target. In cases where the governance executor
// is some contract other than the governor itself, like when using a timelock, this function can be invoked
// in a governance proposal to recover tokens or Ether that was sent to the governor contract by mistake.
// Note that if the executor is simply the governor itself, use of `relay` is redundant.
func relay(target std.Address, value uint64, data []byte) {
	//check for only governance
	// Address.functionCallWithValue(target, data, value);
}

// Address through which the governor executes action. Will be overloaded by module that execute actions
// through another contract such as a timelock.
func _executor() std.Address {}

//todo
// return address(this);

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
