const hre = require("hardhat");

async function main() {

  const [deployer, bob, jane] = await hre.ethers.getSigners();

  const Wm = await hre.ethers.getContractFactory("WagerManager");
  const wm = await Wm.deploy();

  await wm.deployed();

  console.log("Wager Manager deployed to:", wm.address);


  const nicknameTxn = await wm.connect(bob).setNickname("BoobaThaDestroyer");
  await nicknameTxn.wait();

  console.log("Bob nickname:", await wm.getNickname(bob.address));

  const nicknameTxn1 = await wm.connect(jane).setNickname("Janestarr");
  await nicknameTxn1.wait();

  console.log("Jane nickname:", await wm.getNickname(jane.address));

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
