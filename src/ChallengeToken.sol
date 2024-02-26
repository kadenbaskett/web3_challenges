// SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ChallengeToken is ERC1155, Ownable {
    struct ChallengeMetadata {
        string title;
        string description;
        string imageUrl;
    }

    ChallengeMetadata public challengeMetadata;

    // Token ID for the Challenge Token
    uint256 public constant CHALLENGE_TOKEN_ID = 1;

    uint256 public challengesAwarded;

    // track if wallet has received challenge award
    mapping(address => bool) private challengeAwarded;


    constructor(string memory title, string memory description, string memory imageUrl, address owner) ERC1155(title) Ownable(owner) { 
        challengeMetadata = ChallengeMetadata(title, description, imageUrl);
    }

    // Function to mint a single Challenge Token
    function mintChallengeToken(address receivingWallet) public onlyOwner {
        require(!challengeAwarded[receivingWallet], "This wallet has already been awarded a challenge token");
        
        _mint(receivingWallet, CHALLENGE_TOKEN_ID, 1, "");
        challengesAwarded++;
        challengeAwarded[receivingWallet] = true;
    }

    // Function to mint Challenge Tokens to multiple addresses
    function batchMintChallengeTokens(address[] memory receivingWallets) public onlyOwner {
        for (uint256 i = 0; i < receivingWallets.length; i++) {
            address wallet = receivingWallets[i];
            require(!challengeAwarded[wallet], "This wallet has already been awarded a challenge token");

            _mint(wallet, CHALLENGE_TOKEN_ID, 1, "");
            challengesAwarded++;
            challengeAwarded[wallet] = true;
        }
    }

    // Optional: Override uri function if you want to change token URI scheme
    function uri(uint256 tokenId) override public view returns (string memory) {
        return super.uri(tokenId);
    }

    function getChallengeDetails() public view returns (string memory, string memory, string memory) {
        return (challengeMetadata.title, challengeMetadata.description, challengeMetadata.imageUrl);
    }

      function getChallengesAwarded() public view returns (uint256) {
        return challengesAwarded;
    }
}
