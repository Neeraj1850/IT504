//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Certificate is ERC721 {
    using Strings for uint256;

    address public adminAddress;
    uint256 public totalSupply;
    uint256 public noOfStudents;
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
        string studentCourse;
        string studentEmail;
        string studentGPA;
        address studentAddress;

    }

    mapping(address => bool) public isStudent;

    mapping(address => bool) public isMinted;

    mapping(string => StudentInfo) public studentInfo;

    mapping(uint256 => StudentInfo) public studentIndex;


    function setBaseURI(string memory _newBaseURI) public onlyAdmin {
        baseURI = _newBaseURI;
    }

    function changeAdmin (address _newAdmin) external onlyAdmin {
        require(_newAdmin != address(0));
        adminAddress = _newAdmin;
    }

    function addStudentInfo(
        uint256 _studentId,
        string memory _studentCourse,
        string memory _studentEmail,
        string memory _studentGPA
        ) 
        external 
        onlyAdmin {

            require(_studentId != 0, "Student ID cannot be zero");

            StudentInfo memory newStudent = StudentInfo({
                studentId: _studentId,
                studentCourse: _studentCourse,
                studentEmail: _studentEmail,
                studentGPA: _studentGPA,
                studentAddress: address(0)

            });

            studentInfo[_studentEmail] = newStudent;
            

    }

    function addStudentAddress(address _studentAddress, string memory _studentEmail) external onlyAdmin {
        require(_studentAddress != address(0), "Student Address cannot be null");
        StudentInfo storage temp = studentInfo[_studentEmail];
        temp.studentAddress = _studentAddress;
        studentIndex[noOfStudents] = temp;
        noOfStudents += 1;
        
    }

    function batchAddStudentsInfo(
        uint256[] memory _studentIds,
        string[] memory _studentCourses,
        string[] memory _studentEmails,
        string[] memory _studentGPAs
    ) 
    external 
    onlyAdmin 
    {
    require(
        _studentIds.length == _studentCourses.length &&
        _studentCourses.length == _studentEmails.length &&
        _studentEmails.length == _studentGPAs.length,
        "Arrays must be of the same length"
    );

    for (uint i = 0; i < _studentEmails.length; i++) {
        StudentInfo memory newStudent = StudentInfo({
            studentId: _studentIds[i],
            studentCourse: _studentCourses[i],
            studentEmail: _studentEmails[i],
            studentGPA: _studentGPAs[i],
            studentAddress: address(0) // default to address(0), can be updated later
        });

        studentInfo[_studentEmails[i]] = newStudent;
    }
    }

    function batchAddStudentAddress(
        address[] memory _studentAddresses,
        string[] memory _studentEmails
    ) 
    external 
    onlyAdmin 
    {
        require(
            _studentAddresses.length == _studentEmails.length,
            "Arrays must be of the same length"
        );

        for (uint i = 0; i < _studentEmails.length; i++) {
            require(studentInfo[_studentEmails[i]].studentId != 0, "Student must exist");
            
            StudentInfo storage student = studentInfo[_studentEmails[i]];
            student.studentAddress = _studentAddresses[i];
        }
    }

    function batchMint() external onlyAdmin returns (bool){

        for(uint i = 0; i < noOfStudents; i++){
            uint tokenId = studentIndex[i].studentId;
            address to = studentIndex[i].studentAddress;
            require(tokenId != 0 && to != address(0),"Null values received" );
            _safeMint(to, tokenId);
        }

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