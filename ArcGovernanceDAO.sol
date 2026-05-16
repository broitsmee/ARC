// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ArcGovernanceDAO {
    IERC20 public governanceToken; // Voting-er jonno je token use kora hobe (e.g., ARC token)

    struct Proposal {
        uint id;
        address proposer;
        string description;
        uint votesUp;
        uint votesDown;
        uint endTime;
        bool executed;
    }

    mapping(uint => Proposal) public proposals;
    mapping(uint => mapping(address => bool)) public hasVoted; // Ek user jate bar bar vote na dite pare
    uint public proposalCount;
    
    uint public constant VOTING_DURATION = 3 days; // 3 din por vote counting close hobe

    event ProposalCreated(uint id, address proposer, string description);
    event Voted(uint proposalId, address voter, bool support, uint weight);
    event ProposalExecuted(uint proposalId);

    constructor(address _governanceToken) {
        governanceToken = IERC20(_governanceToken);
    }

    // Noton kono proposal toiri kora
    function createProposal(string calldata _description) external returns (uint) {
        // Proposal toiri korte user-er kache ontoto 100 token thakte hobe
        require(governanceToken.balanceOf(msg.sender) >= 100 * 1e18, "Insufficient token to propose");

        proposalCount++;
        Proposal storage newProposal = proposals[proposalCount];
        newProposal.id = proposalCount;
        newProposal.proposer = msg.sender;
        newProposal.description = _description;
        newProposal.endTime = block.timestamp + VOTING_DURATION;
        newProposal.executed = false;

        emit ProposalCreated(proposalCount, msg.sender, _description);
        return proposalCount;
    }

    // Proposal-e Vote deya (Support = true hole "Hae", false hole "Na")
    function vote(uint _proposalId, bool _support) external {
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp < proposal.endTime, "Voting has ended");
        require(!hasVoted[_proposalId][msg.sender], "Already voted on this proposal");

        // User-er kache thaka token balance-i tar vote weight (1 Token = 1 Vote)
        uint voterBalance = governanceToken.balanceOf(msg.sender);
        require(voterBalance > 0, "No voting weight available");

        hasVoted[_proposalId][msg.sender] = true;

        if (_support) {
            proposal.votesUp += voterBalance;
        } else {
            proposal.votesDown += voterBalance;
        }

        emit Voted(_proposalId, msg.sender, _support, voterBalance);
    }

    // Vote sesh hole result execute kora
    function executeProposal(uint _proposalId) external {
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp >= proposal.endTime, "Voting period still active");
        require(!proposal.executed, "Proposal already executed");
        require(proposal.votesUp > proposal.votesDown, "Proposal did not pass");

        proposal.executed = true;

        emit ProposalExecuted(_proposalId);
    }
}
