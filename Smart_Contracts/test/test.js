const { ethers } = require("hardhat");
const { expect } = require("chai").use(require("chai-as-promised"));
const { equal } = require("assert");
require('dotenv').config();

describe ('Test cases', () => {

  let deployer,student1,student2
  let contractInstance
  let contractAddress
  before(async() => {

    
    [deployer, student1, student2] = await ethers.getSigners()
    const contract = await ethers.getContractFactory("Certificate")
    contractInstance = await contract.deploy(deployer,process.env.IPFS_KEY)
    contractAddress = await contractInstance.getAddress()

    console.log(
      "Certificate Contract Address: ",
      contractAddress
    );
    

  })

  it('checks adminAddress function', async() => {
    const admin = await contractInstance.adminAddress()
    equal(admin, deployer.address);
  })

  it('checks add student info function', async() => {
    const studentId = 15700
    const studentCourse = "IT"
    const studentEmail = "1234@gmail.com"
    const studentGPA = "4.1"

    await contractInstance.addStudentInfo(studentId, studentCourse, studentEmail, studentGPA)
    const studentInfo = await contractInstance.studentInfo(studentEmail)

    equal(studentInfo.studentId, 15700)
    equal(studentInfo.studentCourse, "IT")
    equal(studentInfo.studentEmail, "1234@gmail.com")
    equal(studentInfo.studentGPA, "4.1")
    equal(studentInfo.studentAddress, "0x0000000000000000000000000000000000000000")
  })

  it('checks add student address function', async() => {
    const studentEmail = "1234@gmail.com"

    await contractInstance.addStudentAddress(student1.address,studentEmail)
    const studentInfo = await contractInstance.studentInfo(studentEmail)

    equal(studentInfo.studentEmail, studentEmail)
    equal(studentInfo.studentAddress, student1.address)

  })

  it('checks mint function', async() => {
    await contractInstance.batchMint()
    equal(await contractInstance.balanceOf(student1), 1)
    equal(await contractInstance.ownerOf(15700), student1.address)
  })
})

