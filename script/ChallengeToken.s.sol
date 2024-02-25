// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ChallengeToken} from "../src/ChallengeToken.sol";

contract ChallengeTokenScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        new ChallengeToken();
        vm.stopBroadcast();
    }
}
