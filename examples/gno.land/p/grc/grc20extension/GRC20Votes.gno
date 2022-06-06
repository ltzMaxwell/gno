package grc20votes

import grc20 "gno.land/p/grc/grc20/impl"
import votes "gno.land/p/governance/gvotes"
import "std"

const zeroAddress = std.Address("")

type Grc20Votes struct{
	*grc20.Token
	*votes.Votes
}

func NewGrc20Votes(name, symbol string, decimals uint) *Grc20Votes{
	return &Grc20Votes{
		grc20.NewToken(name, symbol, decimals),
		votes.NewVotes(),
	}
}

func (gv *Grc20Votes) _afterTokenTransfer(from std.Address, to std.Address, amount uint64){
	//move voting power
	gv.TransferVotingUnits(from, to, amount)
}

func (gv *Grc20Votes) MintTo(to std.Address, amount uint64){
    gv.Mint(to, amount);
	//init total supply
	//
	gv._afterTokenTransfer(zeroAddress, to ,amount)
}