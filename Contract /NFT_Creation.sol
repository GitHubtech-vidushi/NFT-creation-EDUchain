// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract NFTCreation {
    string public name = "MyNFT";
    string public symbol = "MNFT";
    uint256 public totalSupply = 0;
    address public owner;

    // Token data
    mapping(uint256 => address) public tokenOwner;
    mapping(address => uint256) public balanceOf;
    mapping(uint256 => string) private _tokenURIs;

    // Events
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Minted(address indexed to, uint256 indexed tokenId, string tokenURI);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can perform this action");
        _;
    }

    function mint(address to, string memory metadataURI) public onlyOwner returns (uint256) {
        require(to != address(0), "Cannot mint to zero address");

        uint256 newTokenId = totalSupply + 1;
        tokenOwner[newTokenId] = to;
        balanceOf[to] += 1;
        _tokenURIs[newTokenId] = metadataURI;

        totalSupply += 1;

        emit Transfer(address(0), to, newTokenId);
        emit Minted(to, newTokenId, metadataURI);

        return newTokenId;
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "Token does not exist");
        return _tokenURIs[tokenId];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        require(_exists(tokenId), "Token does not exist");
        return tokenOwner[tokenId];
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return tokenOwner[tokenId] != address(0);
    }
}
