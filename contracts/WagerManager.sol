//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract WagerManager is Ownable {
  using Counters for Counters.Counter;
  Counters.Counter private _wagerIds;

  struct Wager {
    string description;
    address address0;
    address address1;
    uint8 status;          // 0 == 'proposed', 1 == 'denied', 2 == 'active', 3 == 'complete'
    uint8 address0Verdict; // 0 == no verdict given yet, 1 == 'I lost' verdict, 2 == 'I won' verdict
    uint8 address1Verdict;
    uint wagerSize;
  }

  // Mapping from user to list of the wager id's they created
  mapping(address => uint[]) private _userWagers;

  // Mapping from wager id to Wager object
  mapping(uint => Wager) private _allWagers;

  // Mapping of addresses to human-friendly nicknames
  mapping(address => string) private _playerNicknames;

  constructor() {}

  // WAGERS ===================================================================
  
  function createWager(
    address _opponent, 
    uint _wagerSize, 
    string calldata _description
  ) external payable {
    // take money

    // create wager
    Wager memory _newWager = Wager(
      _description,
      msg.sender,
      _opponent,
      0,
      0,
      0,
      _wagerSize
    );

    // add to _userWagers for both users & _allWagers
    _userWagers[msg.sender].push(_wagerIds.current());
    _userWagers[_opponent].push(_wagerIds.current());

    _allWagers[_wagerIds.current()] = _newWager;

    _wagerIds.increment();
  }


  // NICKNAMES ================================================================

  function setNickname(string calldata _nickname) external {
    _playerNicknames[msg.sender] = _nickname;
  }

  function getNickname(address _selectedAddress) public view returns (string memory) {
    return _playerNicknames[_selectedAddress];
  }

}
