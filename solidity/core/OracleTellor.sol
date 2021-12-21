//"SPDX-License-Identifier: UNLICENSED"

pragma solidity >=0.8.0 <0.9.0;

import "https://github.com/tellor-io/usingtellor/blob/master/contracts/UsingTellor.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

import "../imports/IOpenRoles.sol";

import "./OracleBase.sol";

contract OracleTellor is OracleBase, UsingTellor {

    string name; 
    uint256 version = 1; 
    address self_oracleTellor; 
    IOpenRoles roleManager; 
    IERC20 trb; 

    string [] ids;
    string [] baseList; 
    string [] quoteList;  

    mapping(string=>mapping(string=>string)) oracleSymbolByBaseByQuote;
    mapping(string=>mapping(string=>bytes32)) oracleRequestIdByBaseByQuote;

    mapping(string=>bool) isManualData;

    constructor(address _roleManagerAddress, address payable _tellorAddress) UsingTellor(_tellorAddress) {
        self_oracleTellor = address(this); 
        roleManager = IOpenRoles(_roleManagerAddress); 
        trb = IERC20(_tellorAddress);
        initializeOracle(); 
    }
    function getName() override view external returns (string memory _name){
        return name; 
    }

    function getVersion() override view external returns (uint256 _version){
        return version; 
    }

    function getPrice(string memory _base, string memory _quote) override external returns (uint256 _price){
        
        // check allowed 
        require(roleManager.isAllowed(self_oracleTellor, "USER", "getPrice", msg.sender)," OPEN_ORACLE_TELLOR - addOracle- 00 : authorised users only ") ;
        
        // check credit 
        require(hasCredit(), " OPEN_ORACLE_TELLOR - getPrice - 01 : insufficient Tellor funds ");
        bytes32 _queryId = oracleRequestIdByBaseByQuote[_base][_quote];
        ( bool _ifRetrieve, bytes memory _value, uint256 _timestampRetrieved )  = getCurrentValue(_queryId);
        return toUint256(_value);
    }
    
    function getPrice(address _baseErc20, address _quoteErc20) override external returns (uint256 _price){
        require(roleManager.isAllowed(self_oracleTellor, "USER", "getPrice", msg.sender)," OPEN_ORACLE_TELLOR - addOracle- 00 : authorised users only ") ;
    }

    function getPrice(string memory _rawAsset) external returns (uint256 _price) {
        require(roleManager.isAllowed(self_oracleTellor, "USER", "getPrice", msg.sender)," OPEN_ORACLE_TELLOR - addOracle- 00 : authorised users only ") ;       
       // check allowed 
        // check credit 
    }

    function getSupportedAssets() override view external returns (string []memory _base, string[] memory _quote){
        return (baseList, quoteList);
    }

    function getRawAssets() view external returns (string [] memory _rawMarkets) {
        return ids; 
    }

    function initializeOracle() internal returns (bool _initialized) {
        addMarketEntry("ETH", "USD", 1, "ETH/USD");
        addMarketEntry("BTC", "USD", 2, "BTC/USD");
        addMarketEntry("BNB", "USD", 3, "BNB/USD");
        addMarketEntry("BTC/USD [24 hr TWAP]", "[manual data]", 4, "BTC/USD"); // 24 hr TWAP
        addMarketEntry("ETH", "BTC", 5, "ETH/BTC");
        addMarketEntry("BNB", "BTC", 6, "BNB/BTC");
        addMarketEntry("BNB", "ETH", 7, "BNB/ETH");
        addMarketEntry("ETH/USD [24 hr TWAP]", "[manual data]", 8, "ETH/USD"); // 24 hr TWAP
        addMarketEntry("ETH/USD [EOD]", "[manual data]", 9, "ETH/USD"); // EOD
        addMarketEntry("AMPL/USD [custom TWAP]", "[manual data]", 10, "ETH/USD"); // custom TWAP
        addMarketEntry("ZEC", "ETH", 11, "ZEC/ETH");
        addMarketEntry("TRX", "ETH", 12, "TRX/ETH");
        addMarketEntry("XRP", "USD", 13, "XRP/USD");
        addMarketEntry("XMR", "ETH", 14, "XMR/ETH");
        addMarketEntry("ATOM", "USD", 15, "ATOM/USD");
        addMarketEntry("LTC", "USD", 16, "LTC/USD");
        addMarketEntry("WAVES", "BTC", 17, "WAVES/BTC");
        addMarketEntry("REP", "BTC", 18, "REP/BTC");
        addMarketEntry("TUSD", "ETH", 19, "TUSD/ETH");
        addMarketEntry("EOS", "USD", 20, "EOS/USD");
        addMarketEntry("IOTA", "USD", 21, "IOTA/USD");
        addMarketEntry("ETC", "USD", 22, "ETC/USD");
        addMarketEntry("ETH", "PAX", 23, "ETH/PAX");
        addMarketEntry("ETH", "BTC", 24, "ETH/BTC");
        addMarketEntry("USDC", "USDT", 25, "USDC/USDT");
        addMarketEntry("XTZ", "USD", 26, "XTZ/USD");
        addMarketEntry("LINK", "USD", 27, "LINK/USD");
        addMarketEntry("ZRX", "BNB", 28, "ZRX/USD");
        addMarketEntry("ZEC", "USD", 29, "ZEC/USD");
        addMarketEntry("XAU", "USD", 30, "XAU/USD");
        addMarketEntry("MATIC", "USD", 31, "MATIC/USD");
        addMarketEntry("BAT", "USD", 32, "BAT/USD");
        addMarketEntry("ALGO", "USD", 33, "ALGO/USD");
        addMarketEntry("ZRX", "USD", 34, "ZRX/USD");
        addMarketEntry("COS", "USD", 35, "COS/USD");
        addMarketEntry("BCH", "USD", 36, "BCH/USD");
        addMarketEntry("REP", "USD", 37, "REP/USD");
        addMarketEntry("GNO", "USD", 38, "GNO/USD");
        addMarketEntry("DAI", "USD", 39, "DAI/USD");
        addMarketEntry("STEEM", "BTC", 40, "STEEM/BTC");
        addMarketEntry("USPCE", "[manual data]", 41, "USPCE");
        addMarketEntry("BTC", "USD", 42, "BTC/USD");
        addMarketEntry("TRB", "ETH", 43, "TRB/ETH"); 
        addMarketEntry("BTC/USD [1 hr TWAP]", "[manual data]", 44, "BTC/USD"); // 1 hr TWAP
        addMarketEntry("TRB/USD [EOD]", "[manual data]", 45, "TRB/USD"); // EOD
        addMarketEntry("ETH/USD [1 hr TWAP]", "[manual data]", 46, "ETH/USD"); // 1 hr TWAP
        addMarketEntry("BSV", "USD", 47, "BSV/USD"); 
        addMarketEntry("MAKER", "USD", 48, "MAKER/USD");
        addMarketEntry("BCH", "USD", 49, "BCH/USD"); // 24 hr TWAP 
        addMarketEntry("TRB", "USD", 50, "TRB/USD");
        addMarketEntry("XMR", "USD", 51, "XMR/USD");
        addMarketEntry("XFT", "USD", 52, "XFT/USD");
        addMarketEntry("BTCDOMINANCE", "[manual data]", 53, "BTCDOMINANCE");
        addMarketEntry("WAVES", "USD", 54, "WAVES/USD");
        addMarketEntry("OGN", "USD", 55, "OGN/USD");
        addMarketEntry("VIXEOD", "[manual data]", 56, "VIXEOD");
        addMarketEntry("DEFITVL", "[manual data]", 57, "DEFITVL");
        addMarketEntry("DEFIMCAP", "[manual data]", 58, "DEFIMCAP");
        addMarketEntry("ETH", "JPY", 59, "ETH/JPY");
        return true; 
    }

    function addMarketEntry(string memory _base, string memory _quote, uint _requestId, string memory _symbol) internal returns(bool _added) {
        ids.push(_symbol);
        baseList[_requestId] = _base;
        quoteList[_requestId] = _quote;
        if(!isEqual(_quote, "[manual data]")) {
            oracleSymbolByBaseByQuote[_base][_quote] = _symbol;
        }
        oracleRequestIdByBaseByQuote[_base][_quote] = bytes32(_requestId);
        return true; 
    }

    function hasCredit() view internal returns (bool _hasCredit) {
        if( trb.balanceOf(self_oracleTellor) > 10*1e20) {
            return true; 
        }
        return false; 
    }

    function isEqual(string memory a, string memory b ) internal pure returns (bool _isEqual) {
       return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    } 

    function toUint256(bytes memory _bytes) internal pure returns (uint256 value) {
        assembly {
            value := mload(add(_bytes, 0x20))
        }
    }
}