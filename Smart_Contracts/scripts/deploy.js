const hre = require("hardhat");
require('dotenv').config();

async function main() {

  let deployer;
  [deployer] = await hre.ethers.getSigners()
  const contract = await hre.ethers.getContractFactory("Certificate")
  const contractInstance = await contract.deploy(deployer,process.env.IPFS_KEY)
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