// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CuteNinjas is ERC721, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;
    string private _contractBaseURI;
    string private _contractURI;

    uint256 public ninjaPrice = 0.01 ether;
    uint16 public constant MAX_NINJAS = 100;
    uint8 private _totalSupply = 0;
    // string private _baseContractURI;

    constructor(string memory bURI, string memory cURI) ERC721("CuteNinjas", "CNJ") {
      _contractBaseURI = bURI;
      _contractURI = cURI;
    }

    // should return something like: 
    // 
    // {
    //   "name": "CuteNinjas",
    //   "description": "Teleport a cute ninja to defend your kingdom.",
    //   "image": "https://openseacreatures.io/image.png",
    //   "external_link": "https://openseacreatures.io",
    //   "seller_fee_basis_points": 250, # Indicates a 1% seller fee.
    //   "fee_recipient": "0xcbb517E9321304Dd52ffC9d5970597EF76C35d21" # Where seller fees will be paid to.
    // }
    function contractURI() public view returns (string memory) {
      return _contractURI;
    }

    function setContractURI(string memory newContractURI) public onlyOwner {
      _contractURI = newContractURI;
    }

    function getBaseURI() public view returns (string memory) {
      return _contractBaseURI;
    }

    function setBaseURI(string memory newBaseURI) public onlyOwner {
      _contractBaseURI = newBaseURI;
    }

    function totalSupply() view public returns (uint8) {
      return _totalSupply;
    }

    function tokenURI(uint256 tokenId) override view public returns (string memory) {
      return bytes(_contractBaseURI).length > 0 ? string(abi.encodePacked(_contractBaseURI, tokenId.toString())) : "";
    }

    function mintNFT(uint8 numNinjas) public payable {
        require(_totalSupply + numNinjas <= MAX_NINJAS, "Minting would exceed max allowed Ninjas.");
        require(numNinjas <= 2, "You can mint at most 2 ninjas in one transaction.");
        require(msg.value >= ninjaPrice * numNinjas, "Ether value sent is below the price");

        for (uint i=0; i < numNinjas; i++) {
          _tokenIds.increment();
          uint256 newItemId = _tokenIds.current();
          _totalSupply += 1;
          _safeMint(msg.sender, newItemId);
        }
    }
}
