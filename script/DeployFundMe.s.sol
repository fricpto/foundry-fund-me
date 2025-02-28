// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "lib/forge-std/src/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        // Before startBroadcast() -> not a real transaction
        HelperConfig helperconfig = new HelperConfig();
        address ethUSdPriceFeed = helperconfig.activeNetworkConfig();
        vm.startBroadcast();
        FundMe fundme = new FundMe(ethUSdPriceFeed);
        vm.stopBroadcast();
        return fundme;
    }
}
