pragma solidity >=0.5.0;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract BlockchainMe is Ownable {

  using SafeMath for uint256;

  event NewData(uint dataId, string data);

  string[] public dataStore;

  mapping (uint => address) public dataToOwner;
  mapping (address => uint) ownerDataCount;

  function storeData(string _data) internal {
    uint id = dataStore.push(_data) - 1;
    dataToOwner[id] = msg.sender;
    ownerDataCount[msg.sender] = ownerDataCount[msg.sender].add(1);
    emit NewData(id, _data);
  }

}
