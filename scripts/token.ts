/* eslint-disable prettier/prettier */

import { ethers } from "hardhat";

async function main() {


  const Token = await ethers.getContractFactory("BRT");
  const token = await Token.deploy("BRT","B");

  await token.deployed();

  console.log("TokenBRT deployed to:", token.address);
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
