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
    // makeAddr("Jay") return an address
    address USER = makeAddr("Jay");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        // send some ether to USER
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumUsdFive() public view {
        console.log(fundMe.MINIMUM_USD());
        console.log(5e18);
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert(); // the next line should revert
        fundMe.fund(); // send 0 ETH
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); // the next txn sent by the USER
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        address funder = fundMe.getfunder(0);
        assertEq(funder, USER);
    }

    // for best practice
    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithSingleFunder() public funded {
        //arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        //assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
    }

    function testWithdrawFromMultipleFunders() public funded {
        // arrange
        // use uint160 to generate the address using number
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for(uint160 i =startingFunderIndex; i<= numberOfFunders;i++){
            // hoax() is the combination of vm.prank() and vm.deal()
            hoax(address(i),SEND_VALUE);
            // console.log(address(i));
            fundMe.fund{value:SEND_VALUE}();
        }

        //arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        assertEq(address(fundMe).balance,0);
        assertEq(startingOwnerBalance+startingFundMeBalance,fundMe.getOwner().balance);
    }
}
