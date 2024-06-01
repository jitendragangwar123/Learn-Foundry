//SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

//custom error
error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 5e18;
    address private immutable i_owner;

    address[] private s_funders;
    AggregatorV3Interface private s_priceFeed;
    mapping(address => uint256) private s_addressToAmountFunded;
    
    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
        _;
    }

    constructor(address pricefeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(pricefeed);
    }
    
     receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "did not send enough eth"
        );

        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (uint256 i = 0; i < s_funders.length; i++) {
            s_addressToAmountFunded[s_funders[i]] = 0;
        }

        s_funders = new address[](0);
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success, "call failed");
    }
    function withdrawCheaper() public onlyOwner {
        uint256 funders=s_funders.length;
        for (uint256 i = 0; i < funders; i++) {
            s_addressToAmountFunded[s_funders[i]] = 0;
        }
        s_funders = new address[](0);
        (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
        require(success, "transaction failed");
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    function getAddressToAmountFunded(address fundingAddress)
        external
        view
        returns (uint256)
    {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getPriceFeed() public view returns(AggregatorV3Interface){
        return s_priceFeed;
    }
}

