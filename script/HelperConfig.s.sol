// SPDX-License-Modifier
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;
    uint8 public constant DECIMALS=8;
    int256 public constant INITIAL_PRICE = 3000e8;
    struct NetworkConfig {
        address priceFeed;
    }

    constructor(){
        if(block.chainid==11155111){
            activeNetworkConfig=getSeploiaEthConfig();
        }
        else{
            activeNetworkConfig=getAnvilEthConfig();
        }
    }

    function getSeploiaEthConfig() public pure returns (NetworkConfig memory){
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getAnvilEthConfig() public returns(NetworkConfig memory){
        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIMALS,INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: address(mockV3Aggregator)
        });
        return sepoliaConfig;
    }
}