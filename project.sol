// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GamifiedCourses {
    struct User {
        uint256 tokens;
        mapping(string => bool) milestonesCompleted;
    }

    mapping(address => User) private users;
    address public owner;
    uint256 public tokenReward;

    event MilestoneCompleted(address indexed user, string milestone, uint256 tokensEarned);
    event TokensWithdrawn(address indexed user, uint256 tokens);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action");
        _;
    }

    constructor(uint256 _tokenReward) {
        owner = msg.sender;
        tokenReward = _tokenReward;
    }

    function completeMilestone(string memory milestone) public {
        require(!users[msg.sender].milestonesCompleted[milestone], "Milestone already completed");

        users[msg.sender].milestonesCompleted[milestone] = true;
        users[msg.sender].tokens += tokenReward;

        emit MilestoneCompleted(msg.sender, milestone, tokenReward);
    }

    function getTokensBalance() public view returns (uint256) {
        return users[msg.sender].tokens;
    }

    function withdrawTokens() public {
        uint256 amount = users[msg.sender].tokens;
        require(amount > 0, "No tokens to withdraw");

        users[msg.sender].tokens = 0;

        payable(msg.sender).transfer(amount);

        emit TokensWithdrawn(msg.sender, amount);
    }

    function setTokenReward(uint256 _tokenReward) public onlyOwner {
        tokenReward = _tokenReward;
    }

    receive() external payable {}
}

