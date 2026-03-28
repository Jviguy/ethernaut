pragma solidity ^0.8;

contract GasConsumer {
    receive() external payable {
        // sit and jerk it... till out of gas.
        while (true) {
        }
    }
}