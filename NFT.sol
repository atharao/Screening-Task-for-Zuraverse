// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TreeNFT is ERC721, Ownable {
    struct Tree {
        string saplingId;
        string geotag;
        string updatesHash;
        uint256 timestamp;
        uint256[] milestoneTimestamps;
        string[] milestoneDescriptions;
    }
    
    mapping(uint256 => Tree) private tokenIdToTree;

    constructor() ERC721("TreeNFT", "TNFT") {}

    function mintTree(
        address to,
        uint256 tokenId,
        string memory saplingId,
        string memory geotag,
        string memory updatesHash,
        uint256 timestamp
    ) public onlyOwner {
        require(!_exists(tokenId), "Token ID already exists");

        _safeMint(to, tokenId);
        tokenIdToTree[tokenId] = Tree(saplingId, geotag, updatesHash, timestamp, new uint256[](0), new string[](0));
    }

    function getTree(uint256 tokenId) public view returns (
        string memory,
        string memory,
        string memory,
        uint256,
        uint256[] memory,
        string[] memory
    ) {
        require(_exists(tokenId), "Token ID does not exist");
        Tree storage tree = tokenIdToTree[tokenId];

        return (
            tree.saplingId,
            tree.geotag,
            tree.updatesHash,
            tree.timestamp,
            tree.milestoneTimestamps,
            tree.milestoneDescriptions
        );
    }
    
    function addMilestone(uint256 tokenId, uint256 timestamp, string memory description) public onlyOwner {
        require(_exists(tokenId), "Token ID does not exist");
        Tree storage tree = tokenIdToTree[tokenId];
        
        tree.milestoneTimestamps.push(timestamp);
        tree.milestoneDescriptions.push(description);
    }
}
