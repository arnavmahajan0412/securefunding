// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
import './Project.sol';

contract CrowdFund{

    Project[] private projectsCreated;


    event projectStarted(
    Project projectAddress,
    address projectCreator,
    string projectName,
    string projectDescription,
    uint256[] timeline,
    uint256 targetAmount,
    uint256 minimumContribution,
    uint256 numberOfContributors,
    uint256 raisedAmount);

    
    event fundingReceived(
      Project projectAddress,
      uint256 amountRecieved,
      address indexed contributor
    );

    //Creating new projects
    
    function createProject(
    string memory projectName, string memory projectDescription,
    uint256[] memory timeline,uint256 targetAmount,uint256 minimumContribution) public {

    Project newProject= new Project(payable(msg.sender),
    projectName,
    projectDescription,
    timeline,
    targetAmount,
    minimumContribution);

    //Add created project in an array
    projectsCreated.push(newProject);
    
    //Start project
    emit projectStarted(
    newProject,
    msg.sender,
    projectName,
    projectDescription,
    timeline,
    targetAmount,
    minimumContribution,
    0,
    0);

    }


    function getProjectDetails() public view returns(Project[]  memory) {
      return projectsCreated;
    }
    Project  public objectAdd;

    //Temporary function to show details

    function storeAdd(Project p) public{
        objectAdd=p;
    }

    function getProjectInformation() public view returns(address payable projectStarter,
    uint256 minContribution,
    uint256 projectDeadline,
    uint256 goalAmount,
    uint256 currentAmount, 
    string memory title,
    string memory desc){
        Project _project;
         
        _project=Project(objectAdd);
        return _project.getProjectDetails();
      }

      function contribute(Project _projectAddress) public payable{
         
        // Project projectInstance= Project(_projectAddress);
         uint256 minAmount=Project(_projectAddress).minimumContribution();
         require(msg.value>minAmount, 'Contribution amount is low !');
         Project(_projectAddress).contribution{value:msg.value}(msg.sender);
         emit fundingReceived(_projectAddress, msg.value, msg.sender);
      }
    
}