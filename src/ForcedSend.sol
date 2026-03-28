pragma solidity ^0.8.0;

// forcibly send 1 wei using selfdestruct targeting the address.
contract ForcedSend {
    constructor(address payable target) payable {
        selfdestruct(target);
    }
}
