//"SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <0.9.0;

interface IOpenOracle { 

    function getPrice(uint256 _amount, string memory _fromDenomination, string memory _toDenomination ) external returns (uint256 _price);

}