
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


    function logic (uint _amount, uint _timeLock) private view returns(uint){
        uint rate;
        uint daysstaked;
        uint daySec = 86400;
        uint pCent = (33/100) * 1000;
        rate = (_amount * pCent)/1000;
        daysstaked = (block.timestamp - _timeLock) / daySec;

         if( _timeLock > _timeLock * 3 days){
            return (rate * daysstaked) + _amount;

        }
        else{
            return _amount;
        }
    }


    function canStake(uint _amount) payable OnlyApeHolders public{
        require(_amount > 0, "increase the amount you are depositing please!");
        stakeToken.transferFrom(msg.sender, address(this), _amount);

        balances += _amount;
        Owner storage own = brtOwners[Index];
        own.addr = msg.sender;
        own.amount = _amount;
        own.timeLock = block.timestamp;
        Index++;
    }

    function withdrawStake(uint _index) OnlyApeHolders public returns(uint _amount, uint yield){
        
        require(brtOwners[_index].timeLock == brtOwners[_index].timeLock * 30 days, "you will have to wait till staking period is over");
        _amount = brtOwners[_index].amount;
        yield = logic(_amount, brtOwners[_index].timeLock);
        require(stakeToken.transfer(msg.sender, _amount), "Transfer failed");
        return (_amount,yield);
    }


}