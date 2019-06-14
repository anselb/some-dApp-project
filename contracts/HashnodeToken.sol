pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol';

contract HashnodeToken is ERC20Mintable {
  string public name = "Hashnode Token";
  string public symbol = "HT";
  uint8 public decimals = 18;
}
