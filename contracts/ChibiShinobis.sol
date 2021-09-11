// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
// import "hardhat/console.sol";


contract ChibiShinobis is ERC721Enumerable, Ownable {

    using Strings for uint256;

    string _baseTokenURI;
    string _contractURI;
    uint256 private _reserved = 100;
    uint256 private _price = 0.03 ether;
    bool public _paused = true;

    // withdraw addresses
    address t1 = 0x7E67aF7FF72cb87b7B0100cA8128F4673D185234;
    address t2 = 0x7E67aF7FF72cb87b7B0100cA8128F4673D185234;
    address t3 = 0x7E67aF7FF72cb87b7B0100cA8128F4673D185234;
    address t4 = 0x7E67aF7FF72cb87b7B0100cA8128F4673D185234;

    // Chibi Shinobis are so cute, they dont need a lots of complicated code :)
    // 10,000 shinobis in total bc of shadow clone jutsu
    constructor(string memory baseURI, string memory contractDefaultURI) ERC721("Chibi Shinobis", "CHIBIS")  {
        setBaseURI(baseURI);
        setContractURI(contractDefaultURI);

        // team gets the first 4 cats
        _safeMint( t1, 0);
        _safeMint( t2, 1);
        _safeMint( t3, 2);
        _safeMint( t4, 3);
    }

    function clone(uint256 num) public payable {
        uint256 supply = totalSupply();
        require( !_paused,                              "Sale paused" );
        require( num < 4,                               "You can clone a maximum of 3 Shinobis" );
        require( supply + num + _reserved < 10001,      "Exceeds maximum Shinobis supply" );
        require( msg.value >= _price * num,             "Ether sent is not correct" );

        for(uint256 i; i < num; i++){
            _safeMint( msg.sender, supply + i );
        }
    }

    function walletOfOwner(address _owner) public view returns(uint256[] memory) {
        uint256 tokenCount = balanceOf(_owner);

        uint256[] memory tokensId = new uint256[](tokenCount);
        for(uint256 i; i < tokenCount; i++){
            tokensId[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokensId;
    }

    // Just in case Eth does some crazy stuff
    function setPrice(uint256 _newPrice) public onlyOwner() {
        _price = _newPrice;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }

    function setContractURI(string memory newContractURI) public onlyOwner {
        _contractURI = newContractURI;
    }

    function contractURI() public view returns (string memory) {
        return _contractURI;
    }

    function getPrice() public view returns (uint256){
        return _price;
    }

    function giveAway(address _to, uint256 _amount) external onlyOwner() {
        require( _amount <= _reserved, "Exceeds reserved Cat supply" );

        uint256 supply = totalSupply();
        for(uint256 i; i < _amount; i++){
            _safeMint( _to, supply + i );
        }

        _reserved -= _amount;
    }

    function pause(bool val) public onlyOwner {
        _paused = val;
    }

    function withdrawAll() public payable onlyOwner {
        uint256 _each = address(this).balance / 4;
        require(payable(t1).send(_each));
        require(payable(t2).send(_each));
        require(payable(t3).send(_each));
        require(payable(t4).send(_each));
    }
}