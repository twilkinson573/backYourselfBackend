require("@nomiclabs/hardhat-waffle");

require('dotenv').config();

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.4",
    networks: {
    matic: {
      url: process.env.API_URL,
      accounts: [process.env.PRIVATE_KEY]
    },
  },
  etherscan: {
    apiKey: {
      polygon: process.env.ETHERSCAN_API_KEY,
    },
  },

};
