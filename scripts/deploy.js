const hre = require("hardhat");

async function main() {
  const [deployer, bob, jane] = await hre.ethers.getSigners();

  const Usdc = await hre.ethers.getContractFactory("ERC20Mock");
  const usdc = await Usdc.deploy("USDC", "USDC", ethers.utils.parseUnits("1000000"));

  await usdc.transfer(bob.address, ethers.utils.parseUnits("1000"));
  await usdc.transfer(jane.address, ethers.utils.parseUnits("1000"));

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
