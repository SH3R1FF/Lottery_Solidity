// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery 
{
    address public manager;
    address payable[] public participants;

    constructor(){
        manager = msg.sender;
    }

    function alreadyEntered() view public returns(bool)
    {
        for(uint i=0;i<participants.length;i++)
        {
            if(msg.sender == participants[i])
            return true;
        }
        return false;
    } 

    receive() external payable
    {
        require(alreadyEntered() == false,"Participants already entered");
        require(msg.value == 1 ether);
        participants.push(payable(msg.sender));

    }

    function getBalance() view public returns(uint)
    {
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() private view returns(uint)
    {
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }

    function selectWinner() public 
    {
        require(msg.sender == manager);
        require(participants.length>=3);

        uint rand = random();
        uint index = rand % participants.length;
        address payable winner;
        winner = participants[index];
        // return winner;
        winner.transfer(getBalance());
        participants = new address payable[](0);
    }

}