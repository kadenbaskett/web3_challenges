// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {ChallengeRegistry} from "../src/ChallengeRegistry.sol";
import {ChallengeToken} from "../src/ChallengeToken.sol";

contract ChallengeRegistryTest is Test {
    ChallengeRegistry registry;
    address fakeOwner = address(0xb23397f97715118532c8c1207F5678Ed4FbaEA6c);   
    address alice = address(0x1);
    address bob = address(0x2);

    function setUp() public {
        registry = new ChallengeRegistry();
    }

    function testCreateChallenge() public {
        address challengeAddress = registry.createChallenge("1st Challenge", "Really cool challenge", "somebadge.jpeg");
        ChallengeToken challengeContract = ChallengeToken(challengeAddress);
        assertEq(challengeContract.owner(), address(this));
        assertEq(challengeContract.getChallengesAwarded(), 0);
    }

    function testMintChallengeToken() public {
        address challeneAddress = registry.createChallenge("1st Challenge", "Really cool challenge", "somebadge.jpeg");
        ChallengeToken challengeContract = ChallengeToken(challeneAddress);
        challengeContract.mintChallengeToken(alice);
        assertEq(challengeContract.balanceOf(alice, challengeContract.CHALLENGE_TOKEN_ID()), 1);
        assertEq(challengeContract.getChallengesAwarded(), 1);
    }

    function testMintChallengeTokenNonOwner() public {
        address challeneAddress = registry.createChallenge("1st Challenge", "Really cool challenge", "somebadge.jpeg");
        ChallengeToken challengeContract = ChallengeToken(challeneAddress);

        vm.expectRevert();
        vm.prank(fakeOwner);
        challengeContract.mintChallengeToken(alice);
    }

    function testCreateAndMintMultipleChallenges() public {
        address challengeAddress1 = registry.createChallenge("1st Challenge", "Really cool challenge", "somebadge.jpeg");
        ChallengeToken challengeContract1 = ChallengeToken(challengeAddress1);

        address challengeAddress2 = registry.createChallenge("2nd Challenge", "Another really cool challenge", "somebadge.jpeg");
        ChallengeToken challengeContract2 = ChallengeToken(challengeAddress2);

        challengeContract1.mintChallengeToken(bob);
        challengeContract2.mintChallengeToken(bob);
        challengeContract2.mintChallengeToken(alice);

        assertEq(challengeContract1.getChallengesAwarded(), 1);
        assertEq(challengeContract2.getChallengesAwarded(), 2);

        address[] memory bobChallenges = registry.getChallengesOfWallet(bob);
        assertEq(bobChallenges.length, 2); 
        assertEq(bobChallenges[0], challengeAddress1);
        assertEq(bobChallenges[1], challengeAddress2);
    }
}
