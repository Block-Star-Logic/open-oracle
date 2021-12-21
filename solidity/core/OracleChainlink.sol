//"SPDX-License-Identifier: UNLICENSED"

pragma solidity >=0.8.0 <0.9.0;

import "./OracleBase.sol";

contract OracleChainlink is OracleBase {
    
    string name; 
    uint256 version = 1; 

    function getName() override view external returns (string memory _name){
        return name; 
    }

    function getVersion() override view external returns (uint256 _version){
        return version; 
    }

    function getPrice(string memory _base, string memory _quote) override external returns (uint256 _price){

    }
    
    function getPrice(address _baseErc20, address _quoteErc20) override external returns (uint256 _price){

    }

    function getSupportedAssets() override view external returns (string []memory _base, string[] memory _quote){

    }
}