const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  
  const Wm = await hre.ethers.getContractFactory("WagerManager");
  const wm = await Wm.deploy(usdc.address);
  await wm.deployed();
  console.log("Wager manager deployed to: ", wm.address);

  await usdc.connect(bob).approve(wm.address, ethers.utils.parseUnits("1000000"));
  await usdc.connect(jane).approve(wm.address, ethers.utils.parseUnits("1000000"));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
