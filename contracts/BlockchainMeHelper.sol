pragma solidity >=0.5.0;

import "./BlockchainMe.sol";

contract BlockchainMeHelper is BlockchainMe {

  modifier onlyOwnerOf(uint _dataId) {
    require(msg.sender == dataToOwner[_dataId]);
    _;
  }

  function withdraw() external onlyOwner {
    address _owner = owner();
    address payable _wallet = address(uint160(_owner));
    _wallet.transfer(address(this).balance);
  }

  function setDataStoreFee(uint _fee) external onlyOwner {
    blockchainMeFee = _fee;
  }

  // function levelUp(uint _zombieId) external payable {
  //   require(msg.value == blockchainMeFee);
  //   zombies[_zombieId].level = zombies[_zombieId].level.add(1);
  // }

  function changeData(uint _dataId, string calldata _newData) external onlyOwnerOf(_dataId) {
    dataStore[_dataId] = _newData;
  }

  function adminChangeData(uint _dataId, string calldata _newData) external onlyOwner {
    dataStore[_dataId] = _newData;
  }

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
