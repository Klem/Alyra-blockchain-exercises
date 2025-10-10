// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Voting is Ownable {
    uint256 private _winnigProposalId = 0; // default for not mistaking proposal 0 and no results yet;
    WorkflowStatus private _currentStatus;
    mapping(address => Voter) _voters;
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
    // move to voting+
    event reinitialized();

    error invalidWorkflowStatus();
    error invalidStatusTransition();
    error invalidAddress();
    error unregisteredVoter();
    error emptyProposal();

    modifier addressValid(address _address) {
        require(_address != address(0), invalidAddress());
        _;
    }

    modifier registeredVoterOrOwner() {
        require(_voters[msg.sender].isRegistered || msg.sender == owner(), unregisteredVoter());
        _;
    }

    constructor() Ownable(msg.sender) {
        _currentStatus = WorkflowStatus.RegisteringVoters;
    }

    // todo utiliy methods (openRegistration....)
    function moveToWorkflowStatus(WorkflowStatus _newStatus)
        public
        onlyOwner
        returns (WorkflowStatus)
    {
        uint256 ns = uint256(_newStatus);
        uint256 cs = uint256(_currentStatus);
        require(ns == cs + 1, invalidStatusTransition());

        WorkflowStatus previousStatus = _currentStatus;
        _currentStatus = _newStatus;

        emit workflowStatusChange(previousStatus, _newStatus);

        return _newStatus;
    }

    // todo voterAlreadyRegistered
    function addVoter(address _address)
        public
        onlyOwner
        addressValid(_address)
    {
        require(
            _currentStatus == WorkflowStatus.RegisteringVoters,
            invalidWorkflowStatus()
        );

        _voters[_address] = Voter(true, false, 0);
        _registeredAddresses.push(_address);

        emit voterRegistered(_address);
    }

    // todo check for proposal minimum lenght
    // require(bytes(_proposal).length >= 15 , "Your proposal should be at least 15 charachers long");
    function addProposal(string memory _proposal) public registeredVoterOrOwner {
        require(
            _currentStatus == WorkflowStatus.ProposalsRegistrationStarted,
            invalidWorkflowStatus()
        );

        uint256 proposalId = _proposals.length +1; // do not put 0 as a proposalId
        _proposals.push(Proposal(_proposal, proposalId));

        emit proposalRegistered(proposalId);
    }

    // todo make sure proposal exists
    // todo make sure proposal list is not empty
    // todo take blank vote into account
    // todo make sure voter votes only once  if(v.hasVoted) {revert("You have already casted your vote");}
    // require(proposalId >= 0 && proposalId <= proposal.lenght-1)
    function vote(uint256 proposalId) public registeredVoterOrOwner {
        require(
            _currentStatus == WorkflowStatus.VotingSessionStarted,
            invalidWorkflowStatus()
        );

        _proposals[proposalId -1 ].voteCount++;  // take +1 offset into account
        Voter memory v = _voters[msg.sender];
        v.hasVoted = true;
        v.votedProposalId = proposalId;

        emit voted(msg.sender, proposalId);
    }

    function tally() public onlyOwner {
        require(
            _currentStatus == WorkflowStatus.VotingSessionEnded,
            invalidWorkflowStatus()
        );
        
       uint maxVoteCount = 0;

       for (uint256 i = 0; i < _proposals.length; i++) {
            if (_proposals[i].voteCount > maxVoteCount) {
                maxVoteCount = _proposals[i].voteCount;
                _winnigProposalId = i;
            }
        }

        moveToWorkflowStatus(WorkflowStatus.VotesTallied);
    }

    function getVotes() public view registeredVoterOrOwner returns (Voter[] memory) {
        Voter[] memory voters = new Voter[](_registeredAddresses.length);

        for (uint256 i = 0; i <= _registeredAddresses.length; i++) {
            voters[i] = (_voters[_registeredAddresses[i]]);
        }

        return voters;
    }

    // reset all for another round
    function reset() public onlyOwner() {
        for (uint256 i = 0; i <= _registeredAddresses.length; i++) {
            Voter memory v = (_voters[_registeredAddresses[i]]);
            v.isRegistered = false;
            v.hasVoted = false;
            v.votedProposalId = 0;
        }

        delete _proposals;
        delete _registeredAddresses;
        _currentStatus = WorkflowStatus.RegisteringVoters;
        _winnigProposalId = 0;

        emit reinitialized();
    }

    function getWinningProposal() public view returns (uint256) {
        return _winnigProposalId;
    }

    // todo, make sure admin can view too
    function getProposals() public view returns (Proposal[] memory) {
        return _proposals;
    }


    function getWorkflowStatus() public view returns (WorkflowStatus) {
        return _currentStatus;
    }
}
