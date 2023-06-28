// comment-security-tafittechtt@gmail.com
//SPDX-License-Identifier: MIT
pragma solidity >=0.8.8 <0.8.21;



contract TafitInvestments{

    struct Request{
    string description;
    address payable recipient;
    uint value;
    bool completed;
    uint noOfvoters;
    mapping(address=>bool)vote;
}

    mapping(address=>uint) public investors;
    mapping(uint=>Request) public requests;
    uint public numRequests;
    address public manager;
    uint public minimumInvestments;
    uint public deadline;
    uint public project;
    uint public totalInvestments;
    uint public noOfInvestors;

    constructor(uint _project,uint _deadline){
        project=_project;
        deadline=block.timestamp+_deadline;//500 sec + 60 sec = 560 sec
        minimumInvestments = 100 wei;
        manager=msg.sender;

    }

    modifier onlyManager(){
        require(msg.sender==manager, "You are not the manager");
        _;
    }
    function createRequest(string calldata _description, address payable _recipient, uint _value) public onlyManager(){
        Request storage newRequest = requests[numRequests];
        numRequests++;
        newRequest.description= _description;
        newRequest.recipient  = _recipient;
        newRequest.value      = _value;
        newRequest.completed  = false;
        newRequest.noOfvoters = 0;

    }

    function investment()public payable{
        require(block.timestamp<deadline, "Deadline has passed");
        require(msg.value>=minimumInvestments, "Minium Investment required 100 wei");
        

        if(investors[msg.sender]==0){
            noOfInvestors++;
        }
        investors[msg.sender]+=msg.value;
        totalInvestments+=msg.value;
    }

    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }

    function refund() public {
        require(block.timestamp>deadline && totalInvestments<project, "You are not elgibile for refund");
        require(investors[msg.sender]>0, "You are not an Investor");
        payable(msg.sender).transfer(investors[msg.sender]);
        investors[msg.sender]=0;

    }

    function voteRequest(uint _requestNo) public {
        require(investors[msg.sender]>0, "You are not a contributor");
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.vote[msg.sender]==false, "You have already voted");
        thisRequest.vote[msg.sender]=true;
        thisRequest.noOfvoters++;
    }
    function makePayment(uint _requestNo) public onlyManager(){
        require(totalInvestments>=project, "Project goal was not reached");
        Request storage thisRequest= requests[_requestNo];
        require(thisRequest.completed==false, "The request has not been completed");
        require(thisRequest.noOfvoters>noOfInvestors/2, "Majority does not support the Request");
        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed=true;

    }
}