package main

import (
	"std"
	"gno.land/r/foo_governor"
	"gno.land/p/testutils"
)

// const admin = std.Address("g1uuuderyrfvleqmfcx52ynyds2c9wvq87a22yxz")

func main() {
	test1 := testutils.TestAddress("test1")
	println("test1:", test1)
	test2 := testutils.TestAddress("test2")
	println("test2:", test2)
	test3 := testutils.TestAddress("test3")
	println("test3:", test3)
	println("============================")

	std.TestSetOrigCaller(test1)
	// mint
	println("mint")
	foo_governor.Mint(test1, 10000)
	totalSupply := foo_governor.TotalSupply()
	println("total supply:", totalSupply)

	// tranfer
	foo_governor.Transfer(test1, test2, 3000)

	// balance of
	println("balance of test1 is :", foo_governor.BalanceOf(test1))
	println("balance of test2 is :", foo_governor.BalanceOf(test2))

	// getVote
	height := std.GetHeight()
	println("---height is :", height)
	println("height is:", height)
	votes_test1 := foo_governor.GetVotes(test1, height - 1)
	println("test1 votes is:", votes_test1)
	votes_test2 := foo_governor.GetVotes(test2, height - 1)
	println("test2 votes is:", votes_test2)
	// Propose
	var (
		targets []std.Address
	 	values []uint64
 		calldatas []byte
	 	description string
	)
	targets = append(targets, test3)
	values = append(values ,1)
	calldatas = append(calldatas, 65)

	proposalId := foo_governor.Propose(targets, values, calldatas, "")

	println("before voting----------------------------------")
	println("proposal RenderHome:", foo_governor.RenderHome())

	// vote
	std.TestSkipHeights(1)		//skip voting delay period
	weight := foo_governor.CastVote(proposalId, 1)

	println("voted----------------------------------")
	println("weight is: ", weight)
	println("proposal RenderHome:", foo_governor.RenderHome())


	// check result
	std.TestSkipHeights(5)		
	println("after voting period ----------------------------------")
	println("proposal RenderHome:", foo_governor.RenderHome())
}

// Output:
// test1: g1w3jhxap3ta047h6lta047h6lta047h6l4mfnm7
// test2: g1w3jhxapjta047h6lta047h6lta047h6laqcyu4
// test3: g1w3jhxapnta047h6lta047h6lta047h6lzfhfxt
// ============================
// mint
// total supply: 10000
// balance of test1 is : 7000
// balance of test2 is : 3000
// ---height is : 123
// height is: 123
// test1 votes is: 0
// test2 votes is: 0
// before voting----------------------------------
// proposal RenderHome: ***Proposal state is***: Pending
// ***Proposal snapShot is***: 123
// ***Proposal deadLine is***: 128
//
// voted----------------------------------
// weight is:  7000
// proposal RenderHome: ***Proposal state is***: Active
// ***Proposal snapShot is***: 123
// ***Proposal deadLine is***: 128
//
// after voting period ----------------------------------
// proposal RenderHome: ***Proposal state is***: Succeeded
// ***Proposal snapShot is***: 123
// ***Proposal deadLine is***: 128