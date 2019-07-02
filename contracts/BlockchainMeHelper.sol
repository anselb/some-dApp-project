pragma solidity >=0.5.0;

import "./BlockchainMe.sol";

/// @title Helper methods for storing data on the Ethereum Blockchain
/// @author Ansel Bridgewater
/// @dev This contract was inspired by Cryptozombies
contract BlockchainMeHelper is BlockchainMe {

  /// @notice A modifier to specify functions as owner privileges
  /// @dev The id for each piece of data is indexed by 0
  /// @param _dataId The index that corresponds to some data and its owner
  modifier onlyOwnerOf(uint _dataId) {
    require(msg.sender == dataToOwner[_dataId]);
    _;
  }

  /// @notice A function to withdraw the ether from this contract
  /// @dev The _owner address must be converted to a payable address
  /// @dev owner() is a function from OpenZeppelin's Ownable.sol contract
  function withdraw() external onlyOwner {
    address _owner = owner();
    address payable _wallet = address(uint160(_owner));
    _wallet.transfer(address(this).balance);
  }

  /// @notice A function to set the service fee for storing data
  /// @dev onlyOwner is a modifier from OpenZeppelin's Ownable.sol contract
  /// @param _fee The new service fee that will be set
  function setDataStoreFee(uint _fee) external onlyOwner {
    blockchainMeFee = _fee;
  }

  /// @notice A function to overwrite your old data with new data
  /// @param _dataId The index that corresponds to some data and its owner
  /// @param _newData The new data that will overwrite the previous set data
  // TODO: consider a fee for changing data or removing the option to change data
  function changeData(uint _dataId, string calldata _newData) external onlyOwnerOf(_dataId) {
    dataStore[_dataId] = _newData;
  }

  /// @notice The original intention for this function was for an admin to overwrite inapporiate data
  /// @notice The NewData event still gives access to that original data
  /// @dev Owners of the data can still revert to their inapporiate data
  /// @param _dataId The index that corresponds to some data and its owner
  /// @param _newData The new data that will overwrite the previous set data
  // TODO: consider possible ways to prevent inapporiate data, if possible
  function adminChangeData(uint _dataId, string calldata _newData) external onlyOwner {
    dataStore[_dataId] = _newData;
  }

  /// @notice A function to get all the ids of the data that belongs to an owner
  /// @param _owner The owner of the data
  /// @return array of indices that correspond to all the owner's data, in the dataStore
  function getDataByOwner(address _owner) external view returns(uint[] memory) {
    uint[] memory result = new uint[](ownerDataCount[_owner]);
    uint counter = 0;

    for (uint i = 0; i < dataStore.length; i++) {
      if (dataToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }

    return result;
  }

}
