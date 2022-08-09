package main

import (
	"std"
	"gno.land/p/governance/gvotes"
	grc20 "gno.land/p/grc/grc20/impl"
	"gno.land/p/testutils"
)

func main() {
	const zeroAddress = std.Address("")
	test1 := testutils.TestAddress("test1")
	std.TestSetOrigCaller(test1)
	println(test1)

	// mint coin
	amount := uint64(100)
	token := grc20.NewToken("gov", "GOV", 10)
	token.Mint(test1, amount)
	println(token.BalanceOf(test1))
	votes := gvotes.NewVotes()
	votes.TransferVotingUnits(zeroAddress, test1, amount)
	println(votes.RenderHome(test1))
}

// Output:
// g1w3jhxap3ta047h6lta047h6lta047h6l4mfnm7
// 100
// * **Total supply**: 100
// * **votes of g1w3jhxap3ta047h6lta047h6lta047h6l4mfnm7 is**: 100
// * **delegatee of g1w3jhxap3ta047h6lta047h6lta047h6l4mfnm7 is**: g1w3jhxap3ta047h6lta047h6lta047h6l4mfnm7