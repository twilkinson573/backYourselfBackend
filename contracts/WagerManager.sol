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
    uint8 status;          // 0 == 'proposed', 1 == 'denied', 2 == 'active'
    uint8 address0Verdict; // 0 == no verdict given yet, 1 == 'I lost' verdict, 2 == 'I won' verdict
    uint8 address1Verdict;
    uint wagerSize;
  }

  // Mapping from user to list of the wager id's they are involved in
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

    // require transfer of USDC for correct amount to be successful
    // require(IERC20...)

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

    // add to _userWagers for both users, & _allWagers
    _userWagers[msg.sender].push(_wagerIds.current());
    _userWagers[_opponent].push(_wagerIds.current());

    _allWagers[_wagerIds.current()] = _newWager;

    _wagerIds.increment();
  }

  function getWagers() public view returns(Wager[] memory) {
    Wager[] memory _myWagers = new Wager[](_userWagers[msg.sender].length);

    for (uint i=0; i < _myWagers.length; i++) {
      _myWagers[i] = _getWager(_userWagers[msg.sender][i]);
      // _myWagers[i] = (_allWagers[_userWagers[msg.sender][i]]);
    }

    return _myWagers;
  }

  function _getWager(uint _wagerId) internal view returns(Wager memory) {
    return _allWagers[_wagerId];
  }


  function provideWagerResponse(uint _response) public {
    // find correct wager
    // take required money if accepted
    // update wager with the response
  }

  function provideWagerVerdict(uint _verdict) public {
    // find correct wager
    // update it with the verdict
    // if both verdicts present, pay out the wager accordingly
  }


  // NICKNAMES ================================================================

  function setNickname(string calldata _nickname) external {
    _playerNicknames[msg.sender] = _nickname;
  }

  function getNickname(address _selectedAddress) public view returns (string memory) {
    return _playerNicknames[_selectedAddress];
  }

}
