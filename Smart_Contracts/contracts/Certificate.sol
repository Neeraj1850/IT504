//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Certificate is ERC721, Ownable {
    using Strings for uint256;

    address public adminAddress;
    uint256 public totalSupply;
    string public baseURI;
    string public baseExtension = ".json";

    constructor(address _adminAddress, string memory _baseURI_) ERC721("Certificate", "CRTF") {
        adminAddress = _adminAddress;
        baseURI = _baseURI_;
    }

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

    function safeMint(address to, uint256 tokenId) public onlyAdmin {
        _safeMint(to, tokenId);

    }

    function setBaseURI(string memory _newBaseURI) public onlyAdmin {
        baseURI = _newBaseURI;
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
            _exists(tokenID),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory currentBaseURI = _baseURI();

        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        tokenID.toString(),
                        baseExtension
                    )
                )
                : "";

    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }


    
}