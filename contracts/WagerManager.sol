//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract WagerManager is Ownable {
  using Counters for Counters.Counter;
  Counters.Counter private _wagerIds;

  address _wantToken;

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

  constructor(address _initialWantToken) {
    _wantToken = _initialWantToken; // the token we will accept as stakes - ie. USDC
  }

  // WAGERS ===================================================================
  
  function createWager(
    address _opponent, 
    uint _wagerSize, 
    string calldata _description
  ) external {
    require(IERC20(_wantToken).allowance(msg.sender, address(this)) >= _wagerSize, "Insufficient allowance");
    require(IERC20(_wantToken).transferFrom(msg.sender, address(this), _wagerSize), "Transfer failed");

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
    Wager[] memory _wagers = new Wager[](_userWagers[msg.sender].length);

    for (uint i=0; i < _wagers.length; i++) {
      _wagers[i] = _getWager(_userWagers[msg.sender][i]);
    }

    return _wagers;
  }

  function _getWager(uint _wagerId) internal view returns(Wager memory) {
    return _allWagers[_wagerId];
  }


  function provideWagerResponse(uint _wagerId, uint _response) public {
    Wager memory _wager = _getWager(_wagerId);

    // take required money if accepted
    // update wager with the response
  }

  function provideWagerVerdict(uint _wagerId, uint _verdict) public {
    // Wager memory _wager = _getWager(_wagerId);

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
