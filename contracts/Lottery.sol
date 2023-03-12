// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Lottery {
    address public owner;
    address payable[] public players;
    uint256 public minimumBet;
    uint256 public winnerIndex;
    uint256 public totalAmount;
    

    
    constructor(uint256 _minimumBet) {
        owner = msg.sender;
        minimumBet = _minimumBet;     
    }

    function enter() public payable {

        require(msg.value >= minimumBet, "Minimum bet not met.");
        players.push(payable(msg.sender));
        totalAmount += msg.value;
    }

    

    function generateRandomNumber() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, players.length)));
    }

    function pickWinner() public restricted {
        require(players.length > 0, "No players in the lottery.");
        uint256 randomNumber = generateRandomNumber();
        winnerIndex = randomNumber % players.length;
        players[winnerIndex].transfer(totalAmount);
        totalAmount = 0;
        players = new address payable[](0);
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    modifier restricted() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }
}