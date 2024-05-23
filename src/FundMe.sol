//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";


error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18;
    address public immutable i_owner;
    address[] public funders;

    mapping(address => uint256) public addressToAmountFunded;

    constructor() {
        i_owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
        _;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD, "did not send enough eth"); //1e18=1ETH

        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (uint256 i = 0; i < funders.length; i++) {
            addressToAmountFunded[funders[i]] = 0;
        }
        funders = new address[](0);
        (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
        require(success, "transaction failed");
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
