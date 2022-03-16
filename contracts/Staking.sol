
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";



contract Stake{

    string public gateTokenName;
    IERC20 public stakeToken;

    constructor(
        address _stakeTokenAddr
    ) {
        stakeToken = IERC20(_stakeTokenAddr);
    }

    address constant BoredapesNft = 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D;
    uint public balances;

    struct Owner{
        address addr;
        uint amount;
        uint timeLock;
    }

    modifier OnlyApeHolders{
        require(IERC721(BoredapesNft).balanceOf(msg.sender) > 1, "You need to own a BoredApe");

        _;
    }
    

    uint public Index;


    mapping(uint => Owner) public brtOwners;
    mapping(address => Owner) public balanceStaked;
    mapping(address => Owner) public timeOfStaked;


    function logic (uint _amount, uint _timeOfStake) private view returns(uint rate){
        rate = (_amount * 10)/100;

         if( _timeOfStake > block.timestamp * 3 days){
            return rate + _amount;
        }
        else{
            return _amount;
        }
    }


    function canStake(uint _amount, uint _timeLock) payable OnlyApeHolders public{
        require(_amount > 0, "increase the amount you are depositing please!");
        // payable(msg.sender).transfer(address(this), _amount);
        
        balances += _amount;
        Owner storage own = brtOwners[Index];
        own.addr = msg.sender;
        own.amount = _amount;
        own.timeLock = _timeLock;
        Index++;
    }

    function withdrawStake(uint _index) OnlyApeHolders public view returns(uint _amount){

        require(brtOwners[_index].timeLock == brtOwners[_index].timeLock * 30 days, "you will have to wait till staking period is over");
        _amount = brtOwners[_index].amount;
        return logic(_amount, brtOwners[_index].timeLock);
    }


}