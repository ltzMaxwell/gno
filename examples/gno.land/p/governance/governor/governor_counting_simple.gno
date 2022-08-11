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
	voted        *avl.MutTree // address =>  bool
}

type GovernorCountingSimple struct {
	proposalVotes *avl.MutTree // proposalId => proposalVote
	gvqf          *GovernorVotesQuorumFraction
}

func NewGovernorCountingSimple(g20v *grc20votes.Grc20Votes) *GovernorCountingSimple {
	return &GovernorCountingSimple{
		proposalVotes: avl.NewMutTree(),
		// TODO: customize numerator
		gvqf:          NewGovernorVotesQuorumFraction(50, g20v),
	}
}

func (gcs *GovernorCountingSimple) hasVoted(proposalId string, account std.Address) bool {
	proposalVoteI, found := gcs.proposalVotes.Get(proposalId)
	if !found {
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
func (gcs *GovernorCountingSimple) getProposalVotes(proposalId string) (againstVotes uint64, forVotes uint64, abstainVotes uint64) {
	proposalVoteI, found := gcs.proposalVotes.Get(proposalId)
	if !found {
		panic("GCS: proposal not exist")
	}
	proposalVote := proposalVoteI.(*ProposalVote)
	return proposalVote.againstVotes, proposalVote.forVotes, proposalVote.abstainVotes
}

func (gcs *GovernorCountingSimple) quorumReached(proposalId string, snapshot int64) bool {
	proposalVoteI, exists := gcs.proposalVotes.Get(proposalId)
	if !exists {
		panic("GCS: proposal not exist")
	}
	proposalVote := proposalVoteI.(*ProposalVote)

	return gcs.gvqf.quorum(snapshot) <= proposalVote.forVotes+proposalVote.abstainVotes
}

func (gcs *GovernorCountingSimple) voteSucceeded(proposalId string) bool {
	proposalVoteI, found := gcs.proposalVotes.Get(proposalId)
	if !found {
		panic("GCS: proposal not exist")
	}
	proposalVote := proposalVoteI.(*ProposalVote)
	return proposalVote.forVotes > proposalVote.againstVotes
}

func (gcs *GovernorCountingSimple) countVote(proposalId string, account std.Address, support uint8, weight uint64, params []byte) {
	var proposalVote *ProposalVote
	var voted *avl.MutTree

	proposalVoteI, found := gcs.proposalVotes.Get(proposalId)
	if !found {
		proposalVote = &ProposalVote{}
		voted = avl.NewMutTree()
		voted.Set(account.String(), true)

		if support == uint8(Against) {
			proposalVote.againstVotes += weight
		} else if support == uint8(For) {
			proposalVote.forVotes += weight
		} else if support == uint8(Abstain) {
			proposalVote.abstainVotes += weight
		} else {
			panic("GCS: invalid value for enum VoteType")
		}
		proposalVote.voted = voted
	} else {
		proposalVote = proposalVoteI.(*ProposalVote)
		_, exists := proposalVote.voted.Get(account.String())
		// only vote when not voted before
		if !exists {
			// set vote state
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
			panic("GCS: You have voted for this before")
		}
	}
	// update
	gcs.proposalVotes.Set(proposalId, proposalVote)
}
