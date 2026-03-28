pragma solidity ^0.8;

contract MagicNumber {
    constructor() {
        bytes memory code = hex"602a60005260206000f3";
        assembly {
            return(add(code, 0x20), mload(code))
        }
    }
}