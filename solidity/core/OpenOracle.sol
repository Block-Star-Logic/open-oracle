//"SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <0.9.0;


import "../imports/IOpenRoles.sol";

import "../interfaces/IOracleRegistry.sol";
import "../interfaces/IOpenOracle.sol";
import "../interfaces/IOpenOracleRoute.sol";

contract OpenOracle is IOpenOracle { 

    IOpenRoles roleManager; 
    IOracleRegistry registry; 
    address self_openOracle;

    constructor(address _roleManager, address _oracleRegistry) {
        roleManager = IOpenRoles(_roleManager);
        registry = IOracleRegistry(_oracleRegistry);
    }

    function getPrice(uint256 _amount, string memory _fromDenomination, string memory _toDenomination ) override external returns (uint256 _price){
        require(roleManager.isAllowed(self_openOracle, "USER", "getPrice", msg.sender)," OPENPRICING - getPrice - 00 : admin only ") ;
        if(registry.hasRoute(_fromDenomination, _toDenomination)){
            IOpenOracleRoute route = IOpenOracleRoute(registry.getRoute(_fromDenomination, _toDenomination));
            return route.execute(_amount);
        }
        return 0; 
    }
}