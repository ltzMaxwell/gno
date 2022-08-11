package governor

import "std"

type ProposalCreatedEvent struct {
	proposalId  uint64
	proposer    std.Address
	targets     []std.Address
	values      []uint64
	signatures  []string
	calldatas   []byte
	startBlock  uint64
	endBlock    uint64
	description string
}

type ProposalCanceledEvent struct {
	proposalId uint64
}

type ProposalExecutedEvent struct {
	proposalId uint64
}

// Emitted when a vote is cast without params.
// Note: `support` values should be seen as buckets. Their interpretation depends on the voting module used.
type VoteCastEvent struct {
	voter      std.Address
	proposalId uint64
	support    uint8
	weight     uint64
	reason     string
}

// Emitted when a vote is cast with params.
// Note: `support` values should be seen as buckets. Their interpretation depends on the voting module used.
// `params` are additional encoded parameters. Their intepepretation also depends on the voting module used.
type VoteCastWithParamsEvent struct {
	voter      std.Address
	proposalId uint64
	support    uint8
	weight     uint64
	reason     string
	params     []byte
}

type IGovernor interface {
	// Name of the governor instance (used in building the ERC712 domain separator).
	name() string

	// Version of the governor instance (used in building the ERC712 domain separator). Default: "1"
	version() string

	// Hashing function used to (re)build the proposal id from the proposal details..
	hashProposal(targets []std.Address, values []uint64, calldatas []byte, descriptionHash []byte) uint64

	// Current state of a proposal, following Compound's convention
	state(proposalId uint64) ProposalState

	// Block number used to retrieve user's votes and quorum.
	proposalSnapshot(proposalId uint64) uint64

	// Block number at which votes close. Votes close at the end of this block, so it is possible to cast a vote
	// during this block.
	proposalDeadline(proposalId uint64) uint64

	// Delay, in number of block, between the proposal is created and the vote starts. This can be increassed to
	// leave time for users to buy voting power, of delegate it, before the voting of a proposal starts.
	votingDelay() uint64

	// Delay, in number of blocks, between the vote start and vote ends.
	votingPeriod() uint64

	// Minimum number of cast voted required for a proposal to be successful.
	quorum(blockNumber uint32) uint64

	// Voting power of an `account` at a specific `blockNumber`.
	getVotes(account std.Address, blockNumber uint32) uint64

	// Voting power of an `account` at a specific `blockNumber` given additional encoded parameters.
	getVotesWithParams(account std.Address, blockNumber uint32, params []byte) uint64

	// Returns weither `account` has cast a vote on `proposalId`.
	hasVoted(proposalId uint64, account std.Address) bool

	// Create a new proposal. 
	// Emits a ProposalCreated event.
	Propose(targets []std.Address, values []uint64, calldatas []byte, description string) (proposalId uint64)

	// Execute a successful proposal. This requires the quorum to be reached, the vote to be successful, and the
	// deadline to be reached.
	// Emits a ProposalExecutedEvent.
	// Note: some module can modify the requirements for execution, for example by adding an additional timelock.
	execute(targets []std.Address, values []uint64, calldatas []byte, description string) (proposalId uint64)

	// Cast a vote
	// Emits a VoteCastEvent
	castVote(proposalId uint64, support uint8) (balance uint64)

	// Cast a vote with a reason
	// Emits a VoteCastEvent
	castVoteWithReason(proposalId uint64, support uint8, reason string) (balance uint64)

	// Cast a vote with a reason and additional encoded parameters
	// Emits a VoteCastEvent
	castVoteWithReasonAndParams(proposalId uint64, support uint8, reason string, params []byte) (balance uint64)
}
