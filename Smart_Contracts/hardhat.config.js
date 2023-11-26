require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config()

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
  networks: {
    sepolia: {
      url: `https://sepolia.infura.io/v3/${process.env.INFURA_KEY}`,
      accounts: [process.env.PRIVATE_KEY]
    },
    mumbai: {
      url: `https://polygon-mumbai.infura.io/v3/372349b386a442a49f00716d258c7423`,
      accounts: [process.env.PRIVATE_KEY]
    }
  }
};
