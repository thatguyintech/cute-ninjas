// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CuteNinjas is ERC721, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;
    string private _baseURIex;

    uint256 private _price = 0.01 ether;
    uint16 public constant MAX_NINJAS = 100;
    uint8 private _totalSupply = 0;
    // string private _baseContractURI;

    constructor(string memory baseURI) ERC721("CuteNinjas", "CNJ") {
      _baseURIex = baseURI;
    }

    function totalSupply() view public returns (uint8) {
      return _totalSupply;
    }
    
    function priceToMint() view public returns (uint256) {
      return _price;
    }

    function tokenURI(uint256 tokenId) override view public returns (string memory) {
      return bytes(_baseURIex).length > 0 ? string(abi.encodePacked(_baseURIex, tokenId.toString())) : "";
    }

    function mintNFT(uint8 numNinjas) public payable {
        require(_totalSupply + numNinjas <= MAX_NINJAS, "Minting would exceed max allowed Ninjas.");
        require(numNinjas <= 2, "You can mint at most 2 ninjas in one transaction.");
        require(msg.value >= _price * numNinjas, "Ether value sent is below the price");

        for (uint i=0; i < numNinjas; i++) {
          _tokenIds.increment();
          uint256 newItemId = _tokenIds.current();
          _totalSupply += 1;
          _safeMint(msg.sender, newItemId);
        }
    }
}
