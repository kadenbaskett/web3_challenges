// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {ChallengeToken} from "../src/ChallengeToken.sol";

contract ChallengeTokenTest is Test {
    ChallengeToken challengeToken;
    address fakeOwner = address(0xb23397f97715118532c8c1207F5678Ed4FbaEA6c);   
    address alice = address(0x1);
    address bob = address(0x2);

    function setUp() public {
        challengeToken = new ChallengeToken("Test Challenge", "Testing if a user is able to put completed challenge information on chain!", "", address(this));
    }

    function testMintChallengeToken() public {
        challengeToken.mintChallengeToken(alice);
        assertEq(challengeToken.balanceOf(alice, challengeToken.CHALLENGE_TOKEN_ID()), 1);
    }

    function testBatchMintChallengeToken() public {
        address[] memory users = new address[](2);
        users[0] = alice;
        users[1] = bob;
        challengeToken.batchMintChallengeTokens(users);
        assertEq(challengeToken.balanceOf(alice, challengeToken.CHALLENGE_TOKEN_ID()), 1);
        assertEq(challengeToken.balanceOf(bob, challengeToken.CHALLENGE_TOKEN_ID()), 1);
        assertEq(challengeToken.getChallengesAwarded(), 2);
    }

    function testOwnership() public {
        assertEq(challengeToken.owner(), address(this));
        assertNotEq(challengeToken.owner(), fakeOwner);
    }

    function testNonOwnerMintChallenge() public {        
        vm.expectRevert();
        vm.prank(fakeOwner);
	    challengeToken.mintChallengeToken(bob);

        address[] memory users = new address[](2);
        users[0] = alice;
        users[1] = bob;

        vm.expectRevert();
        vm.prank(fakeOwner);
	    challengeToken.batchMintChallengeTokens(users);
    }


    function testGetChallengeDetails() public {
        (string memory title, string memory description, string memory imageUrl) = challengeToken.getChallengeDetails();
        assertEq(title, "Test Challenge");
        assertEq(description, "Testing if a user is able to put completed challenge information on chain!");
        assertEq(imageUrl, "");
    }

    function testDuplicateMints() public {
        challengeToken.mintChallengeToken(alice);
        vm.expectRevert("This wallet has already been awarded a challenge token");
        challengeToken.mintChallengeToken(alice);
    }
}
