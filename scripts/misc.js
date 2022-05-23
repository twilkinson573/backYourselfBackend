const hre = require("hardhat");

async function main() {
  const [deployer, bob, jane] = await hre.ethers.getSigners();

  const wm = await hre.ethers.getContractAt("WagerManager", "0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9");
  console.log("Wager manager found at:", wm.address);
  await wm.setNickname("Burger");
  console.log("Deployer nickname: ", await wm.getNickname(deployer.address));
  console.log("User nickname: ", await wm.getNickname("0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199"));
  console.log("Bob nickname: ", await wm.getNickname(bob.address));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
