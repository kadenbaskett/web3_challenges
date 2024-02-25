// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {ChallengeToken} from "../src/ChallengeToken.sol";

contract ChallengeTokenTest is Test {
    ChallengeToken challengeToken;
    address alice = address(0x1);
    address bob = address(0x2);

    function setUp() public {
        challengeToken = new ChallengeToken();
    }

    function testMintChallengeToken() public {
        challengeToken.mintChallengeToken(alice);
        assertEq(challengeToken.balanceOf(alice, challengeToken.CHALLENGE_TOKEN_ID()), 1);
        assertEq(challengeToken.balanceOf(bob, challengeToken.CHALLENGE_TOKEN_ID()), 0);
        challengeToken.mintChallengeToken(alice);
        assertEq(challengeToken.balanceOf(alice, challengeToken.CHALLENGE_TOKEN_ID()), 2);
    }

    function testOwnership() public {
        assertEq(challengeToken.owner(), address(this));
    }

    function testBatchMintChallengeToken() public {
        address[] memory users = new address[](2);
        users[0] = alice;
        users[1] = bob;
        challengeToken.batchMintChallengeTokens(users);
        assertEq(challengeToken.balanceOf(alice, challengeToken.CHALLENGE_TOKEN_ID()), 1);
        assertEq(challengeToken.balanceOf(bob, challengeToken.CHALLENGE_TOKEN_ID()), 1);
        challengeToken.mintChallengeToken(alice);
        assertEq(challengeToken.balanceOf(alice, challengeToken.CHALLENGE_TOKEN_ID()), 2);
    }
}
