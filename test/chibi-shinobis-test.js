const { expect } = require("chai");
const { ethers } = require("hardhat");
const BASE_URI = "ipfs://FAKE_IPFS_CID/";
const CONTRACT_URI= "ipfs://FAKE_IPFS_CID_FOR_CONTRACT_METADATA";
const CONTRACT_NAME = "ChibiShinobis";

describe(CONTRACT_NAME, function () {
  let contract;

  // `beforeEach` will run before each test, re-deploying the contract every
  // time. It receives a callback, which can be async.
  beforeEach(async function () {
    // Get the ContractFactory and Signers here.
    const Contract = await ethers.getContractFactory(CONTRACT_NAME);
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

    // To deploy our contract, we just have to call Token.deploy() and await
    // for it to be deployed(), which happens once its transaction has been
    // mined.
    contract = await Contract.deploy(BASE_URI, CONTRACT_URI);
  });

  it("Should deploy and set baseURI and contractURI and mint 4 cats to the team", async function () {
    expect(await contract.tokenURI(1)).to.equal(BASE_URI + "1");
    expect(await contract.contractURI()).to.equal(CONTRACT_URI);
    expect(await contract.totalSupply()).to.equal(4);
    expect(await contract.walletOfOwner("0x7E67aF7FF72cb87b7B0100cA8128F4673D185234")).to.have.length(4);
  });

  it("Should mint a new token and return a tokenURI", async function () {
    await contract.pause(false);
    const ninjaPrice = await contract.getPrice();
    expect(await contract.totalSupply()).to.equal(4);
    const tokenId = (await contract.totalSupply());

    expect(
      await contract.clone(1, {
        value: ninjaPrice,
      })
    ).to.emit(contract, "Transfer", "did not emit Transfer event")
    .withArgs(ethers.constants.AddressZero, owner.address, tokenId);

    expect(await contract.balanceOf(owner.address)).to.equal(1, "did not increment minter address's token balance");

    expect(await contract.tokenURI(1)).to.equal(BASE_URI+ "1", "did not compute correct tokenURI for new NFT");
  });
});