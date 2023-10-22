// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {

  let deployer;
  [deployer] = await hre.ethers.getSigners()
  const contract = await hre.ethers.getContractFactory("Certificate")
  const contractInstance = await contract.deploy(deployer,"https://ipfs.io/ipfs/QmcqWehqa5zSZPa9ZPPFPELmq4WAMDqzVLRviPA9Q8BgB4/")
  const contractAddress = await contractInstance.getAddress()

  console.log(
    "Certificate Contract Address: ",
    contractAddress
  );
  

  await contractInstance.addStudentInfo(15600,deployer.address,"IT","3.62")
  await contractInstance.mint()

  const result = await contractInstance.tokenURI(15600)

  console.log(result)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
