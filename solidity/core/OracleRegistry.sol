//"SPDX-License-Identifier: UNLICENSED"

pragma solidity >=0.8.0 <0.9.0;

import "../interfaces/IOracle.sol"; 

import "../interfaces/IOracleRegistry.sol";

contract OracleRegistry is IOracleRegistry {

    mapping(string=>mapping(string=>address[])) oraclesByBaseByQuote;
    mapping(string=>mapping(string=>bool)) hasOracleStatusByBaseByQuote;

    function getOracle(string memory _base, string memory _quote) override view external returns (address _oracleAddress){
        if(hasOracleStatusByBaseByQuote[_base][_quote]) {
            // implement get cheapest 
            return oraclesByBaseByQuote[_base][_quote][0];
        }
        return address(0);
    }

    function addOracle(address _oracle) external returns (address _oracleAddress){
        IOracle oracle = IOracle(_oracle);

        (string [] memory base_, string [] memory quote_) = oracle.getSupportedAssets(); 
        for(uint x = 0; x < base_.length; x++) {
            oraclesByBaseByQuote[base_[x]][quote_[x]].push(_oracle);
        }
        return _oracle; 
    }

    function removeOracle(address _oracle) external returns (address _oracleAddress){
        IOracle oracle = IOracle(_oracle);

        (string [] memory base_, string [] memory quote_) = oracle.getSupportedAssets(); 
        for(uint x = 0; x < base_.length; x++) {
           address [] memory oracles_ = oraclesByBaseByQuote[base_[x]][quote_[x]]; 
           if(oracles_.length > 1){
                oraclesByBaseByQuote[base_[x]][quote_[x]] = deleteEntry(_oracle, oracles_);
           }
           else {
               delete oraclesByBaseByQuote[base_[x]][quote_[x]]; 
           }
        }
        return _oracle; 
    }

    function deleteEntry(address _entry, address [] memory _list) pure internal returns (address [] memory _entryDeleted) {
        uint index = 0; 
        bool indexSet; 
        uint y = 0; 
        address [] memory newList_ = new address[](_list.length-1);
        
        for(uint x = 0; x <_list.length; x++) { 
            if(_list[x] == _entry){
                index = x; 
                indexSet = true; 
            }
            else {
                if(x == (_list.length-1) && !indexSet){
                    return _list; 
                }
                newList_[y] = _list[x];
                y++;
            }
        }
        return newList_; 
    }

}