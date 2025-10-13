// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Voting is Ownable {
    uint256 private _winningProposalId = 0;
    WorkflowStatus private _currentStatus;
    mapping(address => Voter) private _voters;
    address[] private _registeredAddresses;
    Proposal[] private _proposals;

    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint256 votedProposalId;
    }

    struct Proposal {
        string description;
        uint256 voteCount;
    }

    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }

    event voterRegistered(address voterAddress);
    event workflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);
    event proposalRegistered(uint256 proposalId);
    event voted(address voter, uint256 proposalId);

    error invalidWorkflowStatus();
    error invalidStatusTransition();
    error invalidAddress();
    error unregisteredVoterOrNotTheAdmin();
    error unregisteredVoter();
    error emptyProposal();

    modifier addressValid(address _address) {
        require(_address != address(0), invalidAddress());
        _;
    }

    modifier registeredVoterOrOwner() {
        require(_voters[msg.sender].isRegistered || msg.sender == owner(), unregisteredVoterOrNotTheAdmin() );
        _;
    }

     modifier registeredVoter() {
        require(_voters[msg.sender].isRegistered, unregisteredVoter() );
        _;
    }

    constructor() Ownable(msg.sender) {
        _currentStatus = WorkflowStatus.RegisteringVoters;
    }

    function moveToWorkflowStatus(WorkflowStatus _newStatus) public onlyOwner returns (WorkflowStatus)
    {
        uint256 ns = uint256(_newStatus);
        uint256 cs = uint256(_currentStatus);
        require(ns == cs + 1, invalidStatusTransition());

        WorkflowStatus previousStatus = _currentStatus;
        _currentStatus = _newStatus;

        emit workflowStatusChange(previousStatus, _newStatus);

        return _newStatus;
    }


    function addVoter(address _address) public onlyOwner addressValid(_address)
    {
        require(_currentStatus == WorkflowStatus.RegisteringVoters,invalidWorkflowStatus());

        _voters[_address] = Voter(true, false, 0);
        _registeredAddresses.push(_address);

        emit voterRegistered(_address);
    }


    function addProposal(string memory _proposal) public registeredVoter {
        require(_currentStatus == WorkflowStatus.ProposalsRegistrationStarted, invalidWorkflowStatus());

        uint256 proposalId = _proposals.length;
        _proposals.push(Proposal(_proposal, 0));

        emit proposalRegistered(proposalId);
    }

    function vote(uint256 proposalId) public registeredVoter returns (Voter memory){
        require( _currentStatus == WorkflowStatus.VotingSessionStarted, invalidWorkflowStatus() );
        require(!_voters[msg.sender].hasVoted, "Already voted");

        _proposals[proposalId].voteCount++;
        _voters[msg.sender].hasVoted = true;
        _voters[msg.sender].votedProposalId = proposalId;

        emit voted(msg.sender, proposalId);

        return  _voters[msg.sender];
    }

    function tally() public onlyOwner {
        require(_currentStatus == WorkflowStatus.VotingSessionEnded, invalidWorkflowStatus());
        
       uint maxVoteCount = 0;

       for (uint256 i = 0; i < _proposals.length; i++) {
            if (_proposals[i].voteCount > maxVoteCount) {
                maxVoteCount = _proposals[i].voteCount;
                _winningProposalId = i;
            }
        }

        moveToWorkflowStatus(WorkflowStatus.VotesTallied);
    }

    function getVotes() public view registeredVoterOrOwner returns (Voter[] memory) {
        // Count voters who have voted
        uint256 votedCount = 0;
        for (uint256 i = 0; i < _registeredAddresses.length; i++) {
            if (_voters[_registeredAddresses[i]].hasVoted) {
                votedCount++;
            }
        }
    
        Voter[] memory voters = new Voter[](votedCount);
        
        uint256 index = 0;
        for (uint256 i = 0; i < _registeredAddresses.length; i++) {
            if (_voters[_registeredAddresses[i]].hasVoted) {
                voters[index] = _voters[_registeredAddresses[i]];
                index++;
            }
        }

        return voters;
    }
    function getWinningProposal() public view registeredVoterOrOwner returns (Proposal memory) {
        return _proposals[_winningProposalId];
    }

    function getProposals() public view registeredVoterOrOwner returns (Proposal[] memory) {
        return _proposals;
    }


    function getWorkflowStatus() public view registeredVoterOrOwner returns (WorkflowStatus) {
        return _currentStatus;
    }

      function getRegisteredVoters() public view returns (address[] memory) {
        return _registeredAddresses;
    }
}
