pragma solidity ^0.8;

import {ERC20} from "@openzeppelin/token/ERC20/ERC20.sol";

contract MyFakeToken is ERC20 {
    constructor(address dexAddr) ERC20("myfaketoken", "MFT") {
        // give the dex infinite fucking tokens.
        _mint(dexAddr, 2000);
        _mint(msg.sender, 2000);
    }
}