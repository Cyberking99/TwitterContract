// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import "../lib/forge-std/src/console.sol";
import "../src/Twitter.sol";

contract DeployScript is Script {
    Twitter public twitter;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        twitter = new Twitter();

        console.log("Contract Address: ", address(twitter));

        vm.stopBroadcast();
    }
}