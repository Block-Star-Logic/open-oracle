//"SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <0.9.0;


interface IOpenOracleRoute { 

    function getName() view external returns (string memory _routeName);

    function getOriginDestination() view external returns (string memory _origin, string memory _destination);

    function getHopCount() view external returns (uint256 _count);

    function execute(uint256 _amount) external returns (uint256 _toAmount);
    
}
