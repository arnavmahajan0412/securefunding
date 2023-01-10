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
    uint256 raisedAmount,
    uint256 fundraisingDeadline,
    uint256 CurrentState
    );

    
    event fundingReceived(
      Project projectAddress,
      uint256 amountRecieved,
      address indexed contributor
    );

    //Creating new projects
    function createProject(
    string memory projectName, string memory projectDescription,
    uint256[] memory timeline,uint256 targetAmount,uint256 minimumContribution, uint256 fundraisingDeadline) public {

    Project newProject= new Project(payable(msg.sender),
    projectName,
    projectDescription,
    timeline,
    targetAmount,
    minimumContribution,
    fundraisingDeadline);

    //Add created project in array
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
    0,
    fundraisingDeadline,
    0
    );

    }


    function getTotalProjects() public view returns(Project[]  memory) {
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
    string memory desc,
    uint256 fundraisingDL,
    Types.ProjectStates CurrentProjectState
    ){
        Project _project;
         
        _project=Project(objectAdd);
        return _project.getProjectDetails();
      }

    


      //Contribute in a project
      // For investors
      function contribute(Project _projectAddress) public payable{
         
        //Get minimum require amount for project from another contract 
         uint256 minAmount=Project(_projectAddress).minimumContribution();
         require(msg.value>minAmount, 'Contribution amount is low !');
         Project(_projectAddress).contribution{value:msg.value}(msg.sender);
         emit fundingReceived(_projectAddress, msg.value, msg.sender);
      }
    
}