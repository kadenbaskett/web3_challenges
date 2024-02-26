// SPDX-License-Identifier: UNKNOWN 
pragma solidity ^0.8.0;

import "../src/ChallengeToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract ChallengeRegistry is Ownable {
    ChallengeToken[] public challenges;
    mapping(string => address) public titleToContract;

    event ChallengeCreated(address tokenContract); 
    event ChallengeMinted(address tokenContract, address receivingWallet); 

    constructor() Ownable(msg.sender) {}


/*
    deployERC1155 - deploys a ERC1155 token with given parameters - returns deployed address

    _contractName - name of our ERC1155 token
    _uri - URI resolving to our hosted metadata
    _ids - IDs the ERC1155 token should contain
    _name - Names each ID should map to. Case-sensitive.
    */
    function createChallenge(string memory title, string memory description, string memory imageUrl) public returns (address) {
        ChallengeToken c = new ChallengeToken(title, description, imageUrl, msg.sender);
        challenges.push(c);
        titleToContract[title] = address(c);
        emit ChallengeCreated(address(c));
        return address(c);
    }

    function getChallengeAddress(string memory title) public view returns(address){
        return titleToContract[title];
    }

    function getChallengesOfWallet(address wallet) public view returns (address[] memory) {
        address[] memory result = new address[](challenges.length);
        uint256 index = 0;
        for (uint256 i = 0; i < challenges.length; i++) {
            if (ChallengeToken(challenges[i]).balanceOf(wallet, 1) > 0) {
                result[index] = address(challenges[i]);
                index++;
            }
        }
        // Resize the result array to remove any unused slots
        assembly {
            mstore(result, index)
        }
        return result;
    }
}