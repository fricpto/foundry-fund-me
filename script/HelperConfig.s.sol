// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "lib/forge-std/src/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
contract HelperConfig is Script {
    // if we are on a local anvil we deploy mocks
    // Otherwise grab the existing address from the live network
    struct NetworkConfig {
        address pricefeed; // ETH/USD price feed address
    }
    NetworkConfig public activeNetworkConfig;
    uint8 public constant decimals = 8;
    int256 public constant initialAnswer = 2000e8;
    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }
    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            pricefeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        // price feed address
        // we use this if statement to prevent the creation of a new price feed every time we call this function
        if (activeNetworkConfig.pricefeed != address(0)) {
            return activeNetworkConfig;
        }
        // 1. Deploy the mocks
        // 2. Return the mock address
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            decimals,
            initialAnswer
        );
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({
            pricefeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}
