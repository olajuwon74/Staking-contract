
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract Stake {

    string public gateTokenName;
    IERC20 public stakeToken;

    constructor(address _stakeTokenAddr) {
        stakeToken = IERC20(_stakeTokenAddr);
    }

    address constant BoredapesNft = 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D;
    uint profit_frame = 259200;

    struct Owner{
        address addr;
        uint amount;
        uint timeLock;
        bool valid;
    }

    modifier OnlyApeHolders{
        require(IERC721(BoredapesNft).balanceOf(msg.sender) >= 1, "You need to own a BoredApe");
        _;
    }
    

    mapping(address => Owner) public brtStakers;


    function logic (uint _amount, uint _timeLock, address stakerAddress) private view returns(uint){
        _timeLock = brtStakers[stakerAddress].timeLock;
        uint rate;
        uint percent_per_sec = 39;
        uint seconds_staked = block.timestamp - _timeLock;
        rate = ((seconds_staked * percent_per_sec) * _amount)/100000000;
        return rate;
    }
 
     function canStake(uint _amount) OnlyApeHolders public{
         Owner storage own = brtStakers[msg.sender];

         require(stakeToken.balanceOf(msg.sender) >= _amount, "you dont have sufficient amount to stake");
        if(own.valid == true){
            stakeToken.transferFrom(msg.sender, address(this), _amount);
            uint days_already_staked;
            uint latest_amount;
            days_already_staked = block.timestamp - brtStakers[msg.sender].timeLock;

                if(days_already_staked > 3 days){
                latest_amount = stakeYield(msg.sender) + _amount;
                own.amount = latest_amount;
                    own.timeLock = block.timestamp;
                }
                else{
                    latest_amount = _amount + brtStakers[msg.sender].amount;
                    own.amount = latest_amount;
                    own.timeLock = block.timestamp;
                }
        }
         else {
        stakeToken.transferFrom(msg.sender, address(this), _amount);
        own.addr = msg.sender;
        own.amount = _amount;
        own.timeLock = block.timestamp;
        own.valid = true;
         }
    }


     function stakeYield(address _addrs)public returns(uint){
        uint myreturns;
        uint amount;
        uint timelock;
        amount = brtStakers[msg.sender].amount;
        timelock = brtStakers[msg.sender].timeLock;
        myreturns = logic(amount, timelock, msg.sender); 
        return myreturns;
    }


    function withdraw(uint _amount, address addr) public returns(uint){
        Owner storage own = brtStakers[msg.sender];
        uint vault;
        uint days_already_staked = block.timestamp - brtStakers[msg.sender].timeLock;
        require (msg.sender == own.addr, "you cant call this function");
        require (own.valid == true, "you have no money in the stake");
        if (days_already_staked > 3 days){
            vault = stakeYield(addr);
            require(vault >= _amount, "reduce the amount you are trying to withdraw");
            if (vault == _amount){
                 stakeToken.transfer(msg.sender, _amount);
                 own.amount = 0;
                 own.timeLock = block.timestamp;
            }
            else {
               stakeToken.transfer(msg.sender, _amount);
               own.amount = vault - _amount;
               own.timeLock = block.timestamp; 
            }

            }

            else {
               vault = brtStakers[msg.sender].amount;
                if (vault == _amount){
                 stakeToken.transfer(msg.sender, _amount);
                 own.amount = 0;
                 own.timeLock = block.timestamp;
                }
                else {
                stakeToken.transfer(msg.sender, _amount);
                own.amount = vault - _amount;
                own.timeLock = block.timestamp; 
                }

            }
        }

}
