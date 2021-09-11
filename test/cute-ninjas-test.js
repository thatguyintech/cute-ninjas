const { expect } = require("chai");
const { ethers } = require("hardhat");
const BASE_URI = "ipfs://FAKE_IPFS_CID/";
const CONTRACT_URI= "ipfs://FAKE_IPFS_CID_FOR_CONTRACT_METADATA";
const TEST_WALLET = "0x243dc2F47EC5A0693C5c7bD39b31561cCd4B0e97";

describe("CuteNinjas", function () {
  let cuteNinjas;

  // `beforeEach` will run before each test, re-deploying the contract every
  // time. It receives a callback, which can be async.
  beforeEach(async function () {
    // Get the ContractFactory and Signers here.
    const CuteNinjas = await ethers.getContractFactory("CuteNinjas");
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

    // To deploy our contract, we just have to call Token.deploy() and await
    // for it to be deployed(), which happens once its transaction has been
    // mined.
    cuteNinjas = await CuteNinjas.deploy(BASE_URI, CONTRACT_URI);
  });

  it("Should deploy and set baseURI and contractURI", async function () {
    expect(await cuteNinjas.getBaseURI()).to.equal(BASE_URI);
    expect(await cuteNinjas.contractURI()).to.equal(CONTRACT_URI);
  });

  it("Should mint a new token and return a tokenURI", async function () {
    const ninjaPrice = await cuteNinjas.ninjaPrice();
    const tokenId = await cuteNinjas.totalSupply()+1;

    expect(
      await cuteNinjas.mintNFT(1, {
        value: ninjaPrice,
      })
    ).to.emit(cuteNinjas, "Transfer")
    .withArgs(ethers.constants.AddressZero, owner.address, tokenId);
    expect(await cuteNinjas.balanceOf(owner.address)).to.equal(1);

    expect(await cuteNinjas.tokenURI(tokenId)).to.equal(BASE_URI+ "1")
  });
});