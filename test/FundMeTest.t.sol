/*
Testing :- 
1. Unit :- 
    - Testing a specific part of our code
2. Integration :-
    - Testing how our code works with other parts of our code
3. Forked :-
    - Testing our code on a simulated real environment
4. Staging :-
    - Testing our code in a real environment that is not prod   
*/

//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumUsdFive() public view {
        console.log(fundMe.MINIMUM_USD());
        console.log(5e18);
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }
}
