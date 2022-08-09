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
// event VoteCast(address indexed voter, uint256 proposalId, uint8 support, uint256 weight, string reason)
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
	// module:core
	// Name of the governor instance (used in building the ERC712 domain separator).
	name() string

	// module:core
	// Version of the governor instance (used in building the ERC712 domain separator). Default: "1"
	version() string

	// module:core
	// Hashing function used to (re)build the proposal id from the proposal details..
	hashProposal(targets []std.Address, values []uint64, calldatas []byte, descriptionHash []byte) uint64

	// module:core
	// Current state of a proposal, following Compound's convention
	state(proposalId uint64) ProposalState

	// module:core
	// Block number used to retrieve user's votes and quorum. As per Compound's Comp and OpenZeppelin's
	// ERC20Votes, the snapshot is performed at the end of this block. Hence, voting for this proposal starts at the
	// beginning of the following block.
	proposalSnapshot(proposalId uint64) uint64

	// module:core
	// Block number at which votes close. Votes close at the end of this block, so it is possible to cast a vote
	// during this block.
	proposalDeadline(proposalId uint64) uint64

	// module:user-config
	// Delay, in number of block, between the proposal is created and the vote starts. This can be increassed to
	// leave time for users to buy voting power, of delegate it, before the voting of a proposal starts.
	votingDelay() uint64

	// module:user-config
	// Delay, in number of blocks, between the vote start and vote ends.
	// NOTE: The {votingDelay} can delay the start of the vote. This must be considered when setting the voting
	// duration compared to the voting delay.
	votingPeriod() uint64

	// module:user-config
	// Minimum number of cast voted required for a proposal to be successful.
	// Note: The `blockNumber` parameter corresponds to the snaphot used for counting vote. This allows to scale the
	// quroum depending on values such as the totalSupply of a token at this block (see {ERC20Votes}).
	quorum(blockNumber uint32) uint64

	// module:reputation
	// Voting power of an `account` at a specific `blockNumber`.
	// Note: this can be implemented in a number of ways, for example by reading the delegated balance from one (or
	// multiple), {ERC20Votes} tokens.
	getVotes(account std.Address, blockNumber uint32) uint64

	// module:reputation
	// Voting power of an `account` at a specific `blockNumber` given additional encoded parameters.
	getVotesWithParams(account std.Address, blockNumber uint32, params []byte) uint64

	// module:voting
	// Returns weither `account` has cast a vote on `proposalId`.
	hasVoted(proposalId uint64, account std.Address) bool

	// Create a new proposal. Vote start {IGovernor-votingDelay} blocks after the proposal is created and ends
	// {IGovernor-votingPeriod} blocks after the voting starts.
	// Emits a {ProposalCreated} event.
	Propose(targets []std.Address, values []uint64, calldatas []byte, description string) (proposalId uint64)

	// Execute a successful proposal. This requires the quorum to be reached, the vote to be successful, and the
	// deadline to be reached.
	// Emits a {ProposalExecuted} event.
	// Note: some module can modify the requirements for execution, for example by adding an additional timelock.
	execute(targets []std.Address, values []uint64, calldatas []byte, description string) (proposalId uint64)

	// Cast a vote
	// Emits a {VoteCast} event.
	castVote(proposalId uint64, support uint8) (balance uint64)

	// Cast a vote with a reason
	// Emits a {VoteCast} event.
	castVoteWithReason(proposalId uint64, support uint8, reason string) (balance uint64)

	// Cast a vote with a reason and additional encoded parameters
	// Emits a {VoteCast} event.
	castVoteWithReasonAndParams(proposalId uint64, support uint8, reason string, params []byte) (balance uint64)
}
