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
	test2 := testutils.TestAddress("test2")
	std.TestSetOrigCaller(test1)
	println("address of test1 is: ", test1)

	// mint coin
	amount := uint64(100)
	token := grc20.NewToken("gov", "GOV", 10)
	token.Mint(test1, amount)
	println("balance of token is:", token.BalanceOf(test1))

	votes := gvotes.NewVotes()
	println("-------------------------before Delegate-------------------------")
	println(votes.RenderHome(test1))
	println(votes.RenderHome(test2))
	
	votes.Delegate(test2)

	println("-------------------------after Delegate-------------------------")
	println(votes.RenderHome(test1))
	println(votes.RenderHome(test2))
}

// Error:
// no voting units to delegate