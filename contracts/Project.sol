// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Project{
    address payable projectCreator;
    string projectName;
    string projectDescription;
    uint256[] timeline;
    uint256 targetAmount;
    uint256 minimumContribution;
    uint256 numberOfContributors;
    uint256 raisedAmount;
    
    constructor(address payable _projectCreator,
    string memory _projectName,
    string memory _projectDescription,
    uint256[] memory _timeline,
    uint256 _targetAmount,
    uint256 _minimumContribution
    ) {
            projectCreator=_projectCreator;
            projectName=_projectName;
            projectDescription=_projectDescription;
            timeline=_timeline;
            targetAmount=_targetAmount;
            minimumContribution=_minimumContribution;

    }
    
    function getProjectDetails() external view returns(
    address payable projectStarter,
    uint256 minContribution,
    uint256 projectDeadline,
    uint256 goalAmount,
    uint256 currentAmount, 
    string memory title,
    string memory desc
    ){
        projectStarter=projectCreator;
        minContribution=minimumContribution;
        projectDeadline=timeline[timeline.length-1];
        goalAmount=targetAmount;
        currentAmount=raisedAmount;
        title=projectName;
        desc=projectDescription;
    }
    

}