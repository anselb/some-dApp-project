pragma solidity >=0.5.0;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

/// @title A simple app for storing data on the Ethereum Blockchain
/// @author Ansel Bridgewater
contract BlockchainMe is Ownable {

  using SafeMath for uint256;

  event NewData(uint dataId, string data);

  /// @notice The current fee is equal to around 5 USD at time of app creation
  uint blockchainMeFee = 0.017 ether;
  string[] public dataStore;

  mapping (uint => address) public dataToOwner;
  mapping (address => uint) ownerDataCount;

  /// @notice The main function of the app
  /// @param _data The string that will be stored in the dataStore array
  /// @dev The id for each piece of data is indexed by 0
  /// @notice In addition to gas fees, this app also require a "service" fee
  /// @notice This function stores data and counts the number of data instances owned by this user
  function storeData(string calldata _data) external payable {
    require(msg.value == blockchainMeFee);

    uint id = dataStore.push(_data) - 1;
    dataToOwner[id] = msg.sender;
    ownerDataCount[msg.sender] = ownerDataCount[msg.sender].add(1);

    emit NewData(id, _data);
  }

}
