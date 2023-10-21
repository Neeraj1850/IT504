//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Certificate is ERC721, Ownable {
    constructor(address _adminAddress) ERC721("Certificate", "CRTF") {
        adminAddress = _adminAddress;
    }

    /*
     TODO
     1. Add nft properties
     2. Admin modifier
     3. Change Admin function
     4. 

    */

    address public adminAddress;
    uint256 public totalSupply;
    string public baseURI;

    modifier onlyAdmin {
        require(msg.sender == adminAddress,"Caller is not Admin");
        _;
    }

    modifier onlyStudent {
        require(isStudent[msg.sender], "Caller is not Student");
        _;
    }

    struct StudentInfo {
        uint256 studentId;
        address studentAddress;
        string studentCourse;
        string studentGPA;

    }

    mapping(address => bool) public isStudent;

    mapping(address => bool) public isMinted;

    mapping(address => StudentInfo) public studentInfo;

    mapping(uint256 => string) public _tokenURI;

    function safeMint(address to, uint256 tokenId) public onlyAdmin {
        _safeMint(to, tokenId);

    }

    function changeAdmin (address _newAdmin) external onlyAdmin {
        require(_newAdmin != address(0));
        adminAddress = _newAdmin;
    }

    function addStudentInfo(
        uint256 _studentId,
        address _studentAddress, 
        string memory _studentCourse,
        string memory _studentGPA
        ) 
        external 
        onlyOwner {

            StudentInfo memory newStudent = StudentInfo({
                studentId: _studentId,
                studentAddress: _studentAddress,
                studentCourse: _studentCourse,
                studentGPA: _studentGPA

            });

            studentInfo[_studentAddress] = newStudent;
            isStudent[_studentAddress] = true;

    }

    function mint() external onlyStudent returns (bool) {
        require(!isMinted[msg.sender], "Student already minted");

        uint _tokenId = studentInfo[msg.sender].studentId;
        safeMint(msg.sender, _tokenId);
        totalSupply += 1;
        isMinted[msg.sender] = true;


        return true;

    }

    function tokenURI(uint256 tokenID) 
        public 
        view 
        virtual 
        override 
        returns (string memory) 
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        return string(abi.encodePacked(baseURI))



    }


    
}