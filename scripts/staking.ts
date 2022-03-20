/* eslint-disable prettier/prettier */

import { Signer } from "ethers";
import { ethers } from "hardhat";

const stakingAddress = "0x69e642f6BDe7Dbb85245Fb4714A5d99e935ACac0";
const BoredAPEcontract = "0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D";
const BRTContract = "0x0CD3EB8E438922e1345eEF2D9c5a4DCE301D29e5";

async function Staking() {
  // Deploy the stake contract.
  const Staking = await ethers.getContractFactory("Stake");
  const stake = await Staking.deploy(BRTContract);
  await stake.deployed();

  //@ts-ignore
  await hre.network.provider.request({
    method: "hardhat_impersonateAccount",
    params: [stakingAddress],
  });

  //@ts-ignore
  await hre.network.provider.send("hardhat_setBalance", [
    stakingAddress,
    "0x10000000000000000000000000",
  ]);

  // Get the signer to excecute the transfer.
  const signer = await ethers.getSigner(stakingAddress);

  // Check that the staker owns a BRT token.
  const checkToken = await ethers.getContractAt("BRT", BRTContract, signer);
  const balToken = await checkToken.balanceOf(stakingAddress);
  console.log(balToken);

  // Check the number of tokenId that a BoredApe NFT address owns.
  const BoredApeNFTToken = await ethers.getContractAt(
    "IERC721",
    BoredAPEcontract
  );
  const balNFT = await BoredApeNFTToken.balanceOf(stakingAddress);
  console.log(balNFT);

  const done = await stake.connect(signer).canStake(5);
  console.log(done);

  // Check amount of token of the staker after staking.
  const balTokenAfter = await checkToken.balanceOf(stakingAddress);
  console.log(balTokenAfter);
}

Staking().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});