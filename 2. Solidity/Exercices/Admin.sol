// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;
import "@openzeppelin/contracts/access/Ownable.sol";

contract Admin is Ownable {

   constructor() Ownable(msg.sender) {}

    mapping(address => bool) private _whitelist;
    mapping(address => bool) private _blacklist;

    event whitelisted(address _address);
    event blacklisted(address _address);

    modifier notWhitelisted(address _address) {
        require(!_whitelist[_address], "Already whitelisted");
        _;
    }

     modifier notBlacklisted(address _address) {
        require(!_blacklist[_address], "Already blacklisted");
        _;
    }

   
    function whiteList(address _address) public onlyOwner notWhitelisted(_address)
    {
        _whitelist[_address] = true;
        emit whitelisted(_address);
    }

    function blackList(address _address) public onlyOwner notBlacklisted (_address){
        _blacklist[_address] = true;
        emit blacklisted(_address);
    }

    function isBlacklisted(address _address) public view returns (bool) {
        return _blacklist[_address];
    }

    function isWhitelisted(address _address) public view returns (bool) {
        return _whitelist[_address];
    }
}
