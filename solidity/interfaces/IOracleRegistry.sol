//"SPDX-License-Identifier: UNLICENSED"

pragma solidity >=0.8.0 <0.9.0;


interface IOracleRegistry { 

    function getOracle(string memory _base, string memory _quote) view external returns (address _oracleAddress);

}