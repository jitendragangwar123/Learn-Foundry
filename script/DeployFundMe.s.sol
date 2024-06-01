//SPDX-License-Identifier:MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe,HelperConfig) {
        // Before startBroadcast --> Not a real Txn
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();
        // After startBroadcast --> Real Txn
        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return (fundMe, helperConfig);
    }
}
