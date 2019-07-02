pragma solidity >=0.5.0;

import "./BlockchainMeHelper.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

/// @title ERC721 function overriding for use with the data of BlockchainMe
/// @author Ansel Bridgewater
/// @dev This contract was inspired by Cryptozombies, but updated by me to follow the latest ERC721 specification
/// @notice Each piece of data is an ERC721 token
contract BlockchainMeOwnership is BlockchainMeHelper, ERC721 {

  using SafeMath for uint256;

  /// @notice A map of secondary owners that can trade the primary owners data, given that they have permission
  mapping (uint => address) blockchainMeApprovals;

  /// @notice A function to get the number of ERC721 tokens / pieces of data an owner has
  /// @param _owner The owner of the data
  /// @return number of ERC721 tokens / pieces of data an owner has
  function balanceOf(address _owner) public view returns (uint256) {
    return ownerDataCount[_owner];
  }

  /// @notice A function to find out the address that owns a piece of data
  /// @param _dataId The index that corresponds to some data and its owner
  /// @return address of the owner of the data with the given _dataId
  function ownerOf(uint256 _dataId) public view returns (address) {
    return dataToOwner[_dataId];
  }

  /// @notice A function to handle the transfer of ownership of a piece of data
  /// @dev This function can only be called from the function, transferFrom()
  /// @param _from The address of the owner of the data
  /// @param _to The address of the receiver of the data
  /// @param _dataId The index that corresponds to some data and its owner
  function _transfer(address _from, address _to, uint256 _dataId) private {
    ownerDataCount[_to] = ownerDataCount[_to].add(1);
    ownerDataCount[msg.sender] = ownerDataCount[msg.sender].sub(1);
    dataToOwner[_dataId] = _to;
    emit Transfer(_from, _to, _dataId);
  }

  /// @notice A function for an owner or "secondary owner" to transfer ownership of data
  /// @dev This function relies on _transfer()
  /// @param _from The address of the owner of the data
  /// @param _to The address of the receiver of the data
  /// @param _dataId The index that corresponds to some data and its owner
  /// @notice Either the owner or the approved address can transfer the data
  function transferFrom(address _from, address _to, uint256 _dataId) public {
    require (dataToOwner[_dataId] == msg.sender || blockchainMeApprovals[_dataId] == msg.sender);
    _transfer(_from, _to, _dataId);
  }

  /// @notice A function for an owner to give someone else permission to transfer data owned by that owner
  /// @param _approved The address of the "secondary owner", someone who can transfer data owned by someone else
  /// @param _dataId The index that corresponds to some data and its owner
  function approve(address _approved, uint256 _dataId) public onlyOwnerOf(_dataId) {
    blockchainMeApprovals[_dataId] = _approved;
    emit Approval(msg.sender, _approved, _dataId);
  }

}
