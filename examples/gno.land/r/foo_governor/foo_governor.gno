package foo_governor

import "gno.land/p/grc/grc20extension"
import "gno.land/p/governance/governor"
import "gno.land/p/ufmt"	
import "std"


var g20v *grc20votes.Grc20Votes
var gvr *governor.Governor

func init(){
	g20v = grc20votes.NewGrc20Votes("gov", "GOV", 10)
	gvr = governor.NewGovernor(g20v, 0, 5, 0)
}

func Propose(targets []std.Address, values []uint64, calldatas []byte, description string)string{
	proposalId := gvr.Propose(targets, values, calldatas, description)
	return proposalId
}

func CastVote(proposalId string, support uint8)uint64{
	weight := gvr.CastVote(proposalId, support)	
	return weight
}

func GetVotes(account std.Address, blockNumber uint64)uint64{
	return gvr.GetVotes(account, blockNumber)
}

func Mint(to std.Address, amount uint64){
	// ufmt.Sprintf("gv is: %+v", grc20Votes)
	g20v.MintTo(to, amount)
	// ufmt.Sprintf("%s", grc20Votes.Token.GetName())
	// gv.Token.RenderHome()
}

func TotalSupply()uint64{
	return g20v.TotalSupply()
}

func Transfer(from std.Address, to std.Address, amount uint64){
	g20v.TransferTo(from, to, amount)	
}

func BalanceOf(owner std.Address)uint64{
	return g20v.BalanceOf(owner)
}



func RenderHome() string{
	// return g20v.Votes.RenderHome("g1uuuderyrfvleqmfcx52ynyds2c9wvq87a22yxz")
	return gvr.RenderHome("test")
}
