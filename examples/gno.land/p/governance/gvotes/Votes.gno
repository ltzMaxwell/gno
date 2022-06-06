package gvotes

import "gno.land/p/avl"
import  "gno.land/p/governance/checkpoints"
import  "gno.land/p/governance/counters"
import "std"
import "gno.land/p/ufmt"


const zeroAddress = std.Address("")

type Votes struct{
    delegation *avl.MutTree					//address => address
    delegateCheckpoints *avl.MutTree		//address => checkpoints.History
    totalCheckpoints *checkpoints.History 
    nonces *avl.MutTree					    //address => counters.Counter
}

func NewVotes() *Votes{
	return &Votes{
		delegation: avl.NewMutTree(),
		delegateCheckpoints: avl.NewMutTree(),
		totalCheckpoints: &checkpoints.History{},
		nonces: avl.NewMutTree(),
	}
}

/**
  * @dev Returns the current amount of votes that `account` has.
*/
func (v *Votes) GetVotes(account std.Address) uint64{
	res, found := v.delegateCheckpoints.Get(account.String())
	if !found{
		return 0
	}
	history := res.(*checkpoints.History)
	return history.Latest()
}

func (v *Votes) GetPastVotes(account std.Address, blockNumber uint64) uint64{
	history, found := v.delegateCheckpoints.Get(account.String())
	if !found{
		return 0
	}
	return history.(*checkpoints.History).GetAtBlock(blockNumber)
}

func (v *Votes) GetPastTotalSupply(blockNumber uint64) uint64{
	//todo check conversion
	height := uint64(std.GetHeight())
	if blockNumber >= height {
		panic("Votes: block not yet mined")
	}
	return v.totalCheckpoints.GetAtBlock(blockNumber);
}

func (v *Votes) _getTotalSupply() uint64{
	return v.totalCheckpoints.Latest();
}

func (v *Votes) delegates(account std.Address) std.Address{
	delegatee, found := v.delegation.Get(account.String())
	if !found{
		//todo, return self or return error?
		return account
	}
	return delegatee.(std.Address)
}

func (v *Votes) delegate(delegatee std.Address) {
	//todo check caller
	account := std.GetCallerAt(2)
	v._delegate(account, delegatee);
}

func (v *Votes) _delegate(account std.Address,  delegatee std.Address) {
	res, _ := v.delegation.Get(account.String())
	v.delegation.Set(account.String(), delegatee)

	oldDelegate := res.(std.Address)
	//how to emit event
	// emit DelegateChanged(account, oldDelegate, delegatee);
	v._moveDelegateVotes(oldDelegate, delegatee, _getVotingUnits(account))
}

/**
* @dev Transfers, mints, or burns voting units. To register a mint, `from` should be zero. To register a burn, `to`
* should be zero. Total supply of voting units will be adjusted with mints and burns.
*/
func (v *Votes) TransferVotingUnits(from std.Address, to std.Address, amount uint64){
	if from == zeroAddress{
    	v.totalCheckpoints.PushWithOp(_add, amount)
	}
	if to == zeroAddress{
        v.totalCheckpoints.PushWithOp(_subtract, amount)
	}
    v._moveDelegateVotes(v.delegates(from), v.delegates(to), amount)
}

func (v *Votes) _moveDelegateVotes(from std.Address, to std.Address, amount uint64){
	if (from != to && amount > 0) {
		// checkIsValidAddress(from)
		// checkIsValidAddress(to)
		if from != zeroAddress{
			res, exsists := v.delegateCheckpoints.Get(from.String()) 
			if !exsists{
				history := &checkpoints.History{}
		 	   	oldValue, newValue := history.PushWithOp(_subtract, amount)
				v.delegateCheckpoints.Set(from.String(),history)	
				return 
			}
			dCheckPoints := res.(*checkpoints.History)
		    oldValue, newValue := dCheckPoints.PushWithOp(_subtract, amount)
		}
		//todo 
		// emit DelegateVotesChanged(from, oldValue, newValue);
		if to != zeroAddress{
			res, exists := v.delegateCheckpoints.Get(to.String()) 
			if !exists{
				history := &checkpoints.History{}
				oldValue, newValue := history.PushWithOp(_add, amount)
				v.delegateCheckpoints.Set(to.String(),history)
				return
			}
			history := res.(*checkpoints.History)
		    oldValue, newValue := history.PushWithOp(_add, amount)
		}
		//todo
		// emit DelegateVotesChanged(to, oldValue, newValue);
	}
}

func _add(a uint64, b uint64) uint64{
	return a + b
}

func _subtract(a uint64, b uint64) uint64{
	return a - b
}

/**
* @dev Consumes a nonce.
*
* Returns the current value and increments nonce.
*/
func (v *Votes) _useNonce(owner std.Address) uint64{
	res, found := v.nonces.Get(owner.String())
	if !found{
		return 0
	}
	nonce := res.(counters.Counter)
	current := nonce.Current()
	nonce.Increment()
	v.nonces.Set(owner.String(), nonce)
	return current
}

/**
* @dev Returns an address nonce.
*/
func (v *Votes) _getNonce(owner std.Address) uint64{
	res, found := v.nonces.Get(owner.String())
	if !found{
		return 0
	}
	nonce := res.(counters.Counter)
	return nonce.Current()
}


/**
* @dev Must return the voting units held by an account.
*/
func _getVotingUnits(std.Address) uint64{
	//should return balances[account]
}


func checkIsValidAddress(addr std.Address) {
	if addr.String() == "" {
		panic("invalid address")
	}
}


func (v *Votes) RenderHome(account std.Address) string{
	totalSupply := v._getTotalSupply()
	votes := v.GetVotes(account)
	delegatee := v.delegates(account)
	str := ""
	str += ufmt.Sprintf("* **Total supply**: %d\n", totalSupply)
	str += ufmt.Sprintf("* **votes of %s is**: %d\n", account.String(), votes)
	str += ufmt.Sprintf("* **delegatee of %s is**: %s\n", account.String(), delegatee.String())
	return str
}