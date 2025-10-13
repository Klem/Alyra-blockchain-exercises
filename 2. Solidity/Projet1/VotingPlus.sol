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
    event reinitialized();

    error invalidWorkflowStatus();
    error invalidStatusTransition();
    error invalidAddress();
    error unregisteredVoterOrNotTheAdmin();
    error unregisteredVoter();

    modifier addressValid(address _address) {
        require(_address != address(0), invalidAddress());
        _;
    }

    // move to +
    modifier registeredVoterOrOwner() {
        require(_voters[msg.sender].isRegistered || msg.sender == owner(), unregisteredVoterOrNotTheAdmin() );
        _;
    }

    modifier registeredVoter() {
        require(_voters[msg.sender].isRegistered, unregisteredVoter() );
        _;
    }

    modifier voterNotRegistered(address _address) {
        require(!_voters[_address].isRegistered, "Voter Alredy registered" );
        _;
    }

    constructor() Ownable(msg.sender) {
        _currentStatus = WorkflowStatus.RegisteringVoters;
    }

    function _moveToWorkflowStatus(WorkflowStatus _newStatus) private onlyOwner returns (WorkflowStatus)
    {
        uint256 ns = uint256(_newStatus);
        uint256 cs = uint256(_currentStatus);
        require(ns == cs + 1, invalidStatusTransition());

        WorkflowStatus previousStatus = _currentStatus;
        _currentStatus = _newStatus;

        emit workflowStatusChange(previousStatus, _newStatus);

        return _newStatus;
    }

    function startProposalSubmission() public onlyOwner returns (WorkflowStatus) {
           return _moveToWorkflowStatus(WorkflowStatus.ProposalsRegistrationStarted);
    }

    function endProposalSubmission() public onlyOwner returns (WorkflowStatus) {
           require(_proposals.length > 0, "No proposal submitted");
           return _moveToWorkflowStatus(WorkflowStatus.ProposalsRegistrationEnded);
    }

    function startVotingSession() public onlyOwner returns (WorkflowStatus) {
           return _moveToWorkflowStatus(WorkflowStatus.VotingSessionStarted);
    }

    function endVotingSession() public onlyOwner returns (WorkflowStatus) {
           return _moveToWorkflowStatus(WorkflowStatus.VotingSessionEnded);
    }

    // todo voterAlreadyRegistered
    function addVoter(address _address) public onlyOwner addressValid(_address) voterNotRegistered(_address) 
    {
        require(_currentStatus == WorkflowStatus.RegisteringVoters,invalidWorkflowStatus());

        _voters[_address] = Voter(true, false, 0);
        _registeredAddresses.push(_address);

        emit voterRegistered(_address);
    }

    // todo check for proposal minimum lenght
    // 
    function addProposal(string memory _proposal) public registeredVoter {
        require(_currentStatus == WorkflowStatus.ProposalsRegistrationStarted, invalidWorkflowStatus());
        require(bytes(_proposal).length >= 5 , "Your proposal should be at least 5 charachers long");

        uint256 proposalId = _proposals.length;
        _proposals.push(Proposal(_proposal, 0));

        emit proposalRegistered(proposalId);
    }

   
    // todo make sure proposal list is not empty
    // todo take blank vote into account
    // require(proposalId >= 0 && proposalId <= proposal.lenght-1)
    function vote(uint256 proposalId) public registeredVoter returns (Voter memory){
        require( _currentStatus == WorkflowStatus.VotingSessionStarted, invalidWorkflowStatus() );
        require(!_voters[msg.sender].hasVoted, "Already voted");
        require((proposalId >=0 && proposalId < _proposals.length - 1),"Provided proposalId does not exists");

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

        _moveToWorkflowStatus(WorkflowStatus.VotesTallied);
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


    // reset all for another round
    function reset() public onlyOwner() {
        for (uint256 i = 0; i < _registeredAddresses.length; i++) {
            _voters[_registeredAddresses[i]].isRegistered = false;
            _voters[_registeredAddresses[i]].hasVoted = false;
            _voters[_registeredAddresses[i]].votedProposalId = 0;
        }

        delete _proposals;
        delete _registeredAddresses;
        _currentStatus = WorkflowStatus.RegisteringVoters;
        _winningProposalId = 0;

        emit reinitialized();
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
