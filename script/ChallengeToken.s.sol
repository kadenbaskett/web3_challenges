// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ChallengeToken} from "../src/ChallengeToken.sol";

contract ChallengeTokenScript is Script {
    address public ownerWallet;

    constructor(address _ownerWallet) {
        ownerWallet = _ownerWallet;
    }

    function setUp() public {}
    function run() public {
        vm.startBroadcast();
        new ChallengeToken("Test Challenge", "Testing if a user is able to put completed challenge information on chain!", "some.jpeg", ownerWallet);
        vm.stopBroadcast();
    }
}
