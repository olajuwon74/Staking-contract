/* eslint-disable prettier/prettier */

import { ethers } from "hardhat";

async function main() {
    const addr = "0x7d21D6f8e03746BeF7fB64710C1569505F76dC18";

    // @ts-ignore
    await hre.network.provider.request({
        method: "hardhat_impersonateAccount",
        params: [addr],
      });

      // @ts-ignore
      await network.provider.send("hardhat_setBalance", [
        addr,
        "0x2000000000000000000000000000000",
      ]);

    const Token = await ethers.getContractFactory("BRT");
    const signer = await ethers.getSigner(addr);
    const token = await Token.connect(signer).deploy("BRT","B");


  await token.deployed();

  console.log("TokenBRT deployed to:", token.address);
 const balance = await token.totalSupply();
 const balanceOfAddr = await token.balanceOf(addr);
 console.log(`this is the balance of owner ${balanceOfAddr}`);
 console.log(`this is the total supply ${balance}`);

}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
