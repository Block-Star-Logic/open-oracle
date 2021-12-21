//"SPDX-License-Identifier: UNLICENSED"

pragma solidity >=0.8.0 <0.9.0;


interface IOracleRegistry { 

    function getOracle(string memory _base, string memory _quote) view external returns (address _oracleAddress);

    function hasPair(string memory _base, string memory _quote) view external returns (bool _hasPair); 

    function hasRoute(string memory _fromDenomination, string memory _toDenomination) view external returns (bool _hasRoute);

    function getRoute(string memory _fromDemination, string memory _toDenomination) view external returns (address _routeAddress);

}