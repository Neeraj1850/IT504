const { ethers } = require("hardhat");
const { expect } = require("chai").use(require("chai-as-promised"));
const { equal } = require("assert");
const { deployment } = require("../scripts/deploy");
require('dotenv').config();

describe ('Test cases', () => {

  let deployer,student1,student2, student3
  let contractInstance
  let contractAddress
  before(async() => {
   
    ({contractInstance, deployer, student1, student2, student3} = await deployment())
    contractAddress = contractInstance.getAddress()

    console.log(student1.address, student2.address, student3.address)
    
  })

  it('checks adminAddress function', async() => {
    const admin = await contractInstance.adminAddress()
    equal(admin, deployer.address);
  })

  it('checks add student info function', async() => {
    const studentInfo = await contractInstance.studentInfo("1@gmail.com")

    equal(studentInfo.studentId, 15600)
    equal(studentInfo.studentCourse, "IT")
    equal(studentInfo.studentEmail, "1@gmail.com")
    equal(studentInfo.studentGPA, "3.62")
    equal(studentInfo.studentAddress, "0x0000000000000000000000000000000000000000")
  })

  it('checks add student address function', async() => {
    await contractInstance.batchAddStudentAddress(
      [student1.address,student2.address, student3.address],
      ["1@gmail.com", "2@gmail.com", "3@gmail.com"]
    )
    const studentInfo1 = await contractInstance.studentInfo("1@gmail.com")

    equal(studentInfo1.studentEmail, "1@gmail.com")
    equal(studentInfo1.studentAddress, student1.address)

  })

  it('checks mint function', async() => {
    await contractInstance.batchMint()
  
    equal(await contractInstance.ownerOf(15600), student1.address)
    equal(await contractInstance.ownerOf(15700), student2.address)
    equal(await contractInstance.ownerOf(15800), student3.address)
  })
})

