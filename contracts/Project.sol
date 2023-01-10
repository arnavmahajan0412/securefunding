// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

//Using library only for testing smart contract
library Types{
      enum ProjectStates{
        Fundraising,
        Expired,
        Successfull
    }

}

contract Project{


    //States For project(Only for fundraising) 
    // Fundraising= The campaign is accepting funds 
    // expired= Campaign is expired and deadline is passed
    //Successfull= Total amount for the project is received and now the campaign will no receive fund as well
    //  enum ProjectStates{
    //     Fundraising,
    //     Expired,
    //     Successfull
    // }

    address payable projectCreator;
    string projectName;
    string projectDescription;
    uint256[] timeline;
    uint256 targetAmount;
    uint256 public minimumContribution;
    uint256 numberOfContributors;
    uint256 raisedAmount;
    uint256 fundraisingDeadline;
    Types.ProjectStates public ProjectCurrentState= Types.ProjectStates.Fundraising;
    
    mapping(address=>uint256) public contributorsList;

  

    event FundingReceived(address contributor, uint amount, uint currentTotal);

    constructor(address payable _projectCreator,
    string memory _projectName,
    string memory _projectDescription,
    uint256[] memory _timeline,
    uint256 _targetAmount,
    uint256 _minimumContribution,
    uint256 _fundraisinDeadline
    ) {
            projectCreator=_projectCreator;
            projectName=_projectName;
            projectDescription=_projectDescription;
            timeline=_timeline;
            targetAmount=_targetAmount;
            minimumContribution=_minimumContribution;
            fundraisingDeadline=_fundraisinDeadline;
    }
    
    //creating access only for 
    modifier _isCreater(){
        require(msg.sender== projectCreator,'No Access!');
        _;
    }
    //Checking project state for funding 
    modifier _validateExpiryForFunding(Types.ProjectStates _state){
     require(ProjectCurrentState==_state,'Invalid State Cannot Invest in this campaign');
     require(block.timestamp<fundraisingDeadline,'Deadline Passed!');
     _;
    }
    //Check project state for refund
    modifier _validateExpiry(Types.ProjectStates _state){
     require(ProjectCurrentState==_state,'Cannot Refund as campaign is not expired!');   
     _;
    }

    
    //Contribution amount
    function contribution(address _contributor)public _validateExpiryForFunding(Types.ProjectStates.Fundraising) payable{
        require(msg.value>=minimumContribution,'Contribution amount too low !');
        if(contributorsList[_contributor]==0){
            numberOfContributors++;
        }
        contributorsList[_contributor]+=msg.value;
        raisedAmount+=msg.value;
        emit FundingReceived(_contributor,msg.value,raisedAmount);
        checkCampaignStatus();
    }

    //Checking campaign funding status
    //check if campaign has got complete funding
    //check if deadline of campaign is passed
    function checkCampaignStatus()internal{
        if(raisedAmount>=targetAmount){
            ProjectCurrentState=Types.ProjectStates.Successfull;
        }
        else if(block.timestamp>=fundraisingDeadline){
            ProjectCurrentState=Types.ProjectStates.Expired;
        }
    }

    //Refunding Amount if the campaign gets expired
    function refundInvestorsFund()public _validateExpiry(Types.ProjectStates.Expired) returns(bool){
        require(contributorsList[msg.sender] > 0, 'You didnt contributed any amount to this project!');
        address payable user = payable(msg.sender);
        user.transfer(contributorsList[msg.sender]);
        contributorsList[msg.sender] = 0;
        return true;
    }

    //Get project details in frontend
    function getProjectDetails() external view returns(
    address payable projectStarter,
    uint256 minContribution,
    uint256 projectDeadline,
    uint256 goalAmount,
    uint256 currentAmount, 
    string memory title,
    string memory desc,
    uint256 fundraisingDl,
    Types.ProjectStates currentState
    ){
        projectStarter=projectCreator;
        minContribution=minimumContribution;
        projectDeadline=timeline[timeline.length-1];
        goalAmount=targetAmount;
        currentAmount=raisedAmount;
        title=projectName;
        desc=projectDescription;
        fundraisingDl=fundraisingDeadline;
        currentState=ProjectCurrentState;
    }


    

}