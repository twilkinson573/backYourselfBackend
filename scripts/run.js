const hre = require("hardhat");

async function main() {

  // SETUP ====================================================================

  const [deployer, bob, jane] = await hre.ethers.getSigners();

  const Usdc = await hre.ethers.getContractFactory("ERC20Mock");
  const usdc = await Usdc.deploy("USDC", "USDC", ethers.utils.parseUnits("1000000"));

  await usdc.transfer(bob.address, ethers.utils.parseUnits("1000"));
  await usdc.transfer(jane.address, ethers.utils.parseUnits("1000"));

  const Wm = await hre.ethers.getContractFactory("WagerManager");
  const wm = await Wm.deploy(usdc.address);
  await wm.deployed();

  await usdc.connect(bob).approve(wm.address, ethers.utils.parseUnits("1000000"));
  await usdc.connect(jane).approve(wm.address, ethers.utils.parseUnits("1000000"));

  // SET NICKNAMES ============================================================

  const nicknameTxn = await wm.connect(bob).setNickname("BobThaDestroyer");
  await nicknameTxn.wait();

  console.log("Bob nickname:", await wm.getNickname(bob.address));

  const nicknameTxn1 = await wm.connect(jane).setNickname("JanestarrXX");
  await nicknameTxn1.wait();

  console.log("Jane nickname:", await wm.getNickname(jane.address));

  // CREATE WAGERS ============================================================

  // WAGER 0
  await wm.connect(bob).createWager(
    jane.address, 
    ethers.utils.parseUnits("100.0"), 
    "Dry u out at COD"
  );

  // WAGER 1
  await wm.connect(jane).createWager(
    bob.address, 
    ethers.utils.parseUnits("50.0"), 
    "Blitz u in Fifa 1v1"
  );

  // WAGER 2
  await wm.connect(bob).createWager(
    jane.address, 
    ethers.utils.parseUnits("500.0"), 
    "Big stakes pistol duel irl at sunrise"
  );

  await wm.connect(jane).provideWagerResponse(0, 2);
  await wm.connect(bob).provideWagerResponse(1, 2);
  await wm.connect(jane).provideWagerResponse(2, 1);

  console.log("Bob's wagers:", await wm.connect(bob).getWagers());
  console.log("Bob USDC balance:", await usdc.balanceOf(bob.address));
  console.log("Jane USDC balance:", await usdc.balanceOf(jane.address));
  console.log("Deployer USDC balance:", await usdc.balanceOf(deployer.address));

  // WAGER 0 - Disputed, platform takes stake
  await wm.connect(bob).provideWagerVerdict(0, 2);
  await wm.connect(jane).provideWagerVerdict(0, 2);

  // WAGER 1 - Bob wins, platform takes 1%
  await wm.connect(bob).provideWagerVerdict(1, 2);
  await wm.connect(jane).provideWagerVerdict(1, 1);


  console.log("Bob's wagers:", await wm.connect(bob).getWagers());
  console.log("Bob USDC balance:", await usdc.balanceOf(bob.address));
  console.log("Jane USDC balance:", await usdc.balanceOf(jane.address));
  console.log("Deployer USDC balance:", await usdc.balanceOf(deployer.address));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
