package foo_governor

import "gno.land/p/grc/grc20extension"
import "gno.land/p/governance/governor"
import "gno.land/p/ufmt"	
import "std"


var g20v *grc20votes.Grc20Votes
var gvr *governor.Governor

func init(){
	g20v = grc20votes.NewGrc20Votes("gov", "GOV", 10)
	gvr = governor.NewGovernor(g20v, 1, 5, 0)
}

func Propose()string{
	var targets []std.Address
	var values []uint64
	var calldatas []byte
	var description string

	var user0520 std.Address = "g1uuuderyrfvleqmfcx52ynyds2c9wvq87a22yxz" // TODO: helper to change admin

	targets = append(targets, user0520)
	values = append(values ,1)
	calldatas = append(calldatas, 65)

	proposalId := gvr.Propose(targets, values, calldatas, description)
	return proposalId
}

func CastVote()uint64{
	weight := gvr.CastVote("test", 1)	
	return weight
}

func Mint(){
	// ufmt.Sprintf("gv is: %+v", grc20Votes)
	g20v.MintTo("g1uuuderyrfvleqmfcx52ynyds2c9wvq87a22yxz", 10000)
	// ufmt.Sprintf("%s", grc20Votes.Token.GetName())
	// gv.Token.RenderHome()
}

func RenderHome() string{
	// return g20v.Votes.RenderHome("g1uuuderyrfvleqmfcx52ynyds2c9wvq87a22yxz")
	return gvr.RenderHome("test")
}
