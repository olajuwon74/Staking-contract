// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "brt.sol";



contract Stake{

    string public gateTokenName;
    IERC20 public stakeToken;

    constructor(
        address _stakeTokenAddr
    ) {
        stakeToken = IERC20(_stakeTokenAddr);
    }

    address constant BoredapesNft = 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D;
    uint public balance;

    struct Stake_Owners{
        address addr;
        uint amount;
        uint timelock;
        bool valid;
    }



    uint Index;
    uint profit_frame = 259200;

    uint token_amount;
    mapping(address => Stake_Owners) public brtOwners;


    modifier OnlyApeHolders{
        require(IERC721(BoredapesNft).balanceOf(msg.sender) >= 1, "You need to own a BoredApe");

        _;
    }
    

    function stake(uint _amount)  payable OnlyApeHolders public {
        Stake_Owners storage own = brtOwners[msg.sender];
        require(balances[msg.sender] >= _amount, "you dont have sufficient amount to stake");

        if(own.valid == true){
            uint days_already_staked = block.timestamp - own.timelock;
            uint token = own.amount;
            balances[msg.sender] -= _amount;

            if(days_already_staked >= 3 days){
                uint yield = ((token * (days_already_staked /86400)) / 300);
                uint total_yield = yield + _amount;
                own._amount = total_yield;
            }
            else{
                return (`you can't stake again, please wait till ${proof_frame - days_already_staked}`);
            }
        }

        else{
            own.addr = msg.sender;
            own.amount = _amount;
            own.timelock = block.timestamp;
            own.valid = true;
            Index++;  
        }
    }

    function withdraw(uint _amount) public returns (uint total) {
        Stake_Owners storage own = brtOwners[msg.sender];
        require (msg.sender == own.addr, "you cant call this function");
        require (own.valid == true, "you have no money in the stake");
        uint days_already_staked = block.timestamp - own.timelock;
        if (days_already_staked > 3 days){
            uint token = own.amount;
            uint yield = ((token * (days_already_staked /86400)) / 300);
            own.amount += yield;
        }

        else
        require(own.amount >= _amount, "no funds");
        own.amount -= amount;
        balances[address(this)] -= _amount;
        balances[msg.sender] += _amount;
        own.time = block.timestamp;
        own.amount == 0 ? own.valid = false:own.valid == true;  
    }

}