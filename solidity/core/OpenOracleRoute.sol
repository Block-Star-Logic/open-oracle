//"SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <0.9.0;

import "../imports/IOpenRoles.sol";

import "../interfaces/IOracle.sol";
import "../interfaces/IOpenOracleRoute.sol";

contract OpenOracleRoute is IOpenOracleRoute { 

    struct Step { 
        string base; 
        string quote; 
        IOracle oracle; 
    }

    string name; 
    string origin; 
    string destination; 
    uint256 hopCount; 
    Step [] steps; 
    IOpenRoles roleManager; 
    address self_openOracleRoute; 

    constructor(string memory _name, 
                string memory _origin, 
                string memory _destination,
                address _roleManager, 
                address[] memory _oracles, 
                string [] memory _base, 
                string [] memory _quote ){
                self_openOracleRoute = address(this);
                name = _name; 
                origin = _origin; 
                destination = _destination; 
                roleManager = IOpenRoles(_roleManager);

                for(uint x = 0; x < _oracles.length; x++) {
                    Step memory step = Step({
                            base : _base[x],
                            quote : _quote[x],
                            oracle : IOracle(_oracles[x])
                        });
                    steps.push(step);
                }
    }

    function getName() override view external returns (string memory _routeName){
        return name; 
    }

    function getOriginDestination() override view external returns (string memory _origin, string memory _destination){
        return (origin, destination);
    }

    function getHopCount() override view external returns (uint256 _count){
        return hopCount; 
    }

    function execute(uint256 _fromAmount) override external returns (uint256 _toAmount){
        require(roleManager.isAllowed(self_openOracleRoute, "USER", "execute", msg.sender)," OPEN_ORACLE_ROUTE - execute- 00 : authorised users only ") ;

        uint256 factor_ = 0;  
        for(uint x ; x < steps.length; x++) {
            Step memory step = steps[x];
            uint256 price_ = step.oracle.getPrice(step.base, step.quote);
            if(factor_ == 0) {
                factor_ = price_;
            }
            else {
                factor_ = factor_ / price_; // @todo safeMath ...
            }
        }
        return (factor_ * _fromAmount);
    }
    
}