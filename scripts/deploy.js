const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deployer address: ", deployer.address);

  const Wm = await hre.ethers.getContractFactory("WagerManager");
  const wm = await Wm.deploy(process.env.USDC_ADDRESS);
  await wm.deployed();

  console.log("Wager manager deployed to: ", wm.address);

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
