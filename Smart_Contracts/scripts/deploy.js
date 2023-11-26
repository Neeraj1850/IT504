const hre = require("hardhat");
const { metadata } = require("./metadataGenerator");
require('dotenv').config();

async function deployment() {

  let deployer;
  [deployer, student1, student2, student3] = await hre.ethers.getSigners()
  const contract = await hre.ethers.getContractFactory("Certificate")
  await metadata()
  const contractInstance = await contract.deploy(deployer, process.env.EMAIL, process.env.IPFS_KEY)
  const contractAddress = await contractInstance.getAddress()

  console.log(
    "Certificate Contract Address: ",
    contractAddress
  );
  
  //Adding Student Info
  await contractInstance.batchAddStudentsInfo(
    [15600,15700,15800],
    ["IT","MISSM","MISSAM"],
    ["1@gmail.com","2@gmail.com","3@gmail.com"],
    ["3.62","3.7","3.9"]
  )

  return {
    contractInstance,
    deployer, student1, student2, student3
  }

}

deployment()

//module.exports = {deployment}
