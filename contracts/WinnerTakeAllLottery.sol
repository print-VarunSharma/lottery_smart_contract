// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// This is a WIP currently and does not have full end to end stable functionality yet.
contract LotteryDrawToken {
    // This ticket, or rather a draw into the lottery is to be minted to the player upon successful payment into the winnings pool
    mapping(address => uint256) public balances;

    function mint() public {
        balances[tx.origin]++;
    }
}

contract WinnerTakeAllLottery {
    /* This smart contract represents a winner-take-all style lottery. 
    - players can contribute a specific amount of eth which grants them 1 entry into the lottery.
    - at the end of the day, a randomize selection of the draws is conducted, and a winner is arbitrarily chosen.
    - The reward is whoever wins, receives the entire pool of lottery draw contributions.
    - The admin of the lottery contract can initiate the draw at any time as well.
    
    - The admin wallet is both the admin and the holder of the pool
    */

   address payable wallet
   address public _lotteryToken
   uint256 public lastDraw;


     
   constructor(address payable _wallet, address _lotteryToken) public {
    wallet = _wallet;
    lotteryToken = _lotteryToken;
   }

   function() external payable {
    buyLotteryDraw();
   }

    function Time_call() returns (uint256){
        return block.number; 
    }

   function buyLotteryDraw public payable {
    LotteryDrawToken _lotteryToken = LotteryDrawToken(address(lotteryToken));
    _lotteryToken.mint()
   }


    function triggerDailyDraw() external {
        uint256 dayInSeconds = 86400;
        uint256 currentTimestamp = block.timestamp;
        uint256 lastDrawDay = lastDraw / dayInSeconds;
        uint256 currentDay = currentTimestamp / dayInSeconds;

        if (currentDay > lastDrawDay) {
            uint256 nineAM = currentDay * dayInSeconds + 9 hours;
            if (currentTimestamp >= nineAM) {
                // Call your daily function here
                lastDraw = currentTimestamp;
            }
        }
    }
}