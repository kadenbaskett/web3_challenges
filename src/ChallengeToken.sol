// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ChallengeToken is ERC1155, Ownable {
    // Token ID for the Challenge Token
    uint256 public constant CHALLENGE_TOKEN_ID = 1;

    constructor() ERC1155("http://localhost:8080/api/challenges/testChallenge.json") Ownable(msg.sender) {}

    // Function to mint a single Challenge Token
    function mintChallengeToken(address user) public onlyOwner {
        _mint(user, CHALLENGE_TOKEN_ID, 1, "");
    }

    // Function to mint Challenge Tokens to multiple addresses
    function batchMintChallengeTokens(address[] memory users) public onlyOwner {
        for (uint256 i = 0; i < users.length; i++) {
            _mint(users[i], CHALLENGE_TOKEN_ID, 1, "");
        }
    }

    // Optional: Override uri function if you want to change token URI scheme
    function uri(uint256 tokenId) override public view returns (string memory) {
        return super.uri(tokenId);
    }
}
