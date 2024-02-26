// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ChallengeRegistry} from "../src/ChallengeRegistry.sol";

contract ChallengeRegistryScript is Script {


    function setUp() public {}
    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        new ChallengeRegistry();
        vm.stopBroadcast();
    }
}
