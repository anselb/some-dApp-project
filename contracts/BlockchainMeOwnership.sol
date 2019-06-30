pragma solidity >=0.5.0;

import "./BlockchainMeHelper.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

/// TODO: Replace this with natspec descriptions
contract BlockchainMeOwnership is BlockchainMeHelper, ERC721 {

  using SafeMath for uint256;

  mapping (uint => address) blockchainMeApprovals;

  function balanceOf(address _owner) public view returns (uint256) {
    return ownerDataCount[_owner];
  }

  function ownerOf(uint256 _dataId) public view returns (address) {
    return dataToOwner[_dataId];
  }

  function _transfer(address _from, address _to, uint256 _dataId) private {
    ownerDataCount[_to] = ownerDataCount[_to].add(1);
    ownerDataCount[msg.sender] = ownerDataCount[msg.sender].sub(1);
    dataToOwner[_dataId] = _to;
    emit Transfer(_from, _to, _dataId);
  }

  function transferFrom(address _from, address _to, uint256 _dataId) public {
    require (dataToOwner[_dataId] == msg.sender || blockchainMeApprovals[_dataId] == msg.sender);
    _transfer(_from, _to, _dataId);
  }

  function approve(address _approved, uint256 _dataId) public onlyOwnerOf(_dataId) {
    blockchainMeApprovals[_dataId] = _approved;
    emit Approval(msg.sender, _approved, _dataId);
  }

}
