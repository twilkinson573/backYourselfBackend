//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract WagerManager is Ownable {

  struct Wager {
    string description;
    address address0;
    address address1;
    uint8 address0Verdict; // null == no verdict given yet, 0 == 'I lost' verdict, 1 == 'I won' verdict
    uint8 address1Verdict;
    uint depositSize;
    uint depositDate;
  }

  // Mapping of addresses to human-friendly nicknames
  mapping(address => string) private _playerNicknames;


  // // Mapping from owner to list of owned token IDs
  // mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
  // // Mapping from token ID to index of the owner tokens list
  // mapping(uint256 => uint256) private _ownedTokensIndex;
  // // Array with all token ids, used for enumeration
  // uint256[] private _allTokens;
  // // Mapping from token id to position in the allTokens array
  // mapping(uint256 => uint256) private _allTokensIndex;
  // // Mapping from token id to Ticket MetaData
  // // TODO2 - remove public modifier (just for dev -> inspection)
  // mapping(uint => LotteryTicketMeta) public lotteryTickets;


  constructor() {
  }

  function setNickname(string calldata _nickname) public {
    _playerNicknames[msg.sender] = _nickname;
  }

  function getNickname(address _selectedAddress) public view returns (string memory) {
    return _playerNicknames[_selectedAddress];
  }

}
