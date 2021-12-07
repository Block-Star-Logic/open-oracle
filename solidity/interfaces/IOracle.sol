//"SPDX-License-Identifier: UNLICENSED"

pragma solidity >=0.8.0 <0.9.0;

interface IOracle { 

    function getName() view external returns (string memory _name);

    function getVersion() view external returns (uint256 _version);

    function getPrice(string memory _base, string memory _quote) external returns (uint256 _price);

    function getPrice(address _baseErc20, address _quoteErc20) external returns (uint256 _price);

    function getSupportedAssets() view external returns (string []memory _base, string[] memory _quote);

}