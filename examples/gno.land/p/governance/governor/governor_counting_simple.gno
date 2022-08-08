package governor

import (
	"std"
	"gno.land/p/avl"
	"gno.land/p/grc/grc20extension"
)

type VoteType int

const (
	Against VoteType = iota
	For
	Abstain
)

type ProposalVote struct {
	againstVotes uint64
	forVotes     uint64
	abstainVotes uint64
	voted        *avl.MutTree //address =>  bool
}

type GovernorCountingSimple struct {
	_proposalVotes *avl.MutTree //proposalId => proposalVote
	gvqf           *GovernorVotesQuorumFraction
}

func NewGovernorCountingSimple(g20v *grc20votes.Grc20Votes) *GovernorCountingSimple {
	return &GovernorCountingSimple{
		//todo
		_proposalVotes: avl.NewMutTree(),
		gvqf:           NewGovernorVotesQuorumFraction(50, g20v),
	}
}

// See {IGovernor-hasVoted}.
func (gcs *GovernorCountingSimple) hasVoted(proposalId string, account std.Address) bool {
	proposalVoteI, found := gcs._proposalVotes.Get(proposalId)
	if !found {
		// return false
		panic("GCS: proposal not exist")
	}

	proposalVote := proposalVoteI.(*ProposalVote)

	hasVotedI, found := proposalVote.voted.Get(account.String())
	if !found {
		return false
	}
	return hasVotedI.(bool)
}

// Accessor to the internal vote counts.
func (gcs *GovernorCountingSimple) proposalVotes(proposalId string) (againstVotes uint64, forVotes uint64, abstainVotes uint64) {
	proposalVoteI, found := gcs._proposalVotes.Get(proposalId)
	if !found {
		//  return 0, 0, 0
		panic("GCS: proposal not exist")
	}
	proposalVote := proposalVoteI.(*ProposalVote)
	return proposalVote.againstVotes, proposalVote.forVotes, proposalVote.abstainVotes
}

// See {Governor-_quorumReached}.
func (gcs *GovernorCountingSimple) _quorumReached(proposalId string, snapshot uint64) bool {
	proposalVoteI, exists := gcs._proposalVotes.Get(proposalId)
	if !exists {
		panic("GCS: proposal not exist")
	}
	proposalVote := proposalVoteI.(*ProposalVote)

	return gcs.gvqf.quorum(snapshot) <= proposalVote.forVotes+proposalVote.abstainVotes
}

// See {Governor-_voteSucceeded}. In this module, the forVotes must be strictly over the againstVotes.
func (gcs *GovernorCountingSimple) _voteSucceeded(proposalId string) bool {
	proposalVoteI, found := gcs._proposalVotes.Get(proposalId)
	if !found {
		// return false
		panic("GCS: proposal not exist")
	}
	proposalVote := proposalVoteI.(*ProposalVote)
	return proposalVote.forVotes > proposalVote.againstVotes
}

// See {Governor-_countVote}. In this module, the support follows the `VoteType` enum (from Governor Bravo).
func (gcs *GovernorCountingSimple) _countVote(proposalId string, account std.Address, support uint8, weight uint64, params []byte) {
	var proposalVote *ProposalVote
	var _voted *avl.MutTree

	proposalVoteI, found := gcs._proposalVotes.Get(proposalId)
	if !found {
		proposalVote = &ProposalVote{}
		_voted = avl.NewMutTree()

		_voted.Set(account.String(), true)

		if support == uint8(Against) {
			proposalVote.againstVotes += weight
		} else if support == uint8(For) {
			proposalVote.forVotes += weight
		} else if support == uint8(Abstain) {
			proposalVote.abstainVotes += weight
		} else {
			panic("GCS: invalid value for enum VoteType")
		}
		proposalVote.voted = _voted
	} else {
		proposalVote = proposalVoteI.(*ProposalVote)
		_, exists := proposalVote.voted.Get(account.String())
		//only vote when not voted before
		if !exists {
			//set vote state
			proposalVote.voted.Set(account.String(), true)

			if support == uint8(Against) {
				proposalVote.againstVotes += weight
			} else if support == uint8(For) {
				proposalVote.forVotes += weight
			} else if support == uint8(Abstain) {
				proposalVote.abstainVotes += weight
			} else {
				panic("GCS: invalid value for enum VoteType")
			}
		} else {
			panic("You have voted for this before")
		}
	}
	//update
	gcs._proposalVotes.Set(proposalId, proposalVote)
	//filter double vote
	// voted := votedI.(bool)
	// if voted{
	// panic("GovernorVotingSimple vote alreay cast")
	// }
}
