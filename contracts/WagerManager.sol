//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract WagerManager is Ownable {
  using Counters for Counters.Counter;
  Counters.Counter private _wagerIds;

  address public wantToken;
  address private _deployer;

  struct Wager {
    string description;
    address address0;
    address address1;
    uint8 status;          // 0 == 'proposed', 1 == 'declined', 2 == 'active', 3 = 'complete'
    uint8 address0Verdict; // 0 == no verdict given yet, 1 == 'I lost' verdict, 2 == 'I won' verdict
    uint8 address1Verdict;
    uint wagerSize;
    uint wagerId;
  }

  // Mapping from user to list of the wager id's they are involved in
  mapping(address => uint[]) private _userWagers;

  // Mapping from wager id to Wager object
  mapping(uint => Wager) private _allWagers;

  // Mapping of addresses to human-friendly nicknames
  mapping(address => string) private _playerNicknames;

  event wagerCreated(
    address indexed address0,
    address indexed address1,
    uint wagerSize,
    string description,
    uint wagerId
  );

  constructor(address _initialWantToken) {
    wantToken = _initialWantToken; // the token we will accept as stakes - ie. USDC
    _deployer = msg.sender;
  }

  // WAGERS ===================================================================
  
  function createWager(
    address _opponent, 
    uint _wagerSize, 
    string calldata _description
  ) external {
    require(IERC20(wantToken).allowance(msg.sender, address(this)) >= _wagerSize, "Insufficient allowance");
    require(IERC20(wantToken).transferFrom(msg.sender, address(this), _wagerSize), "Transfer failed");

    // create wager
    Wager memory _newWager = Wager(
      _description,
      msg.sender,
      _opponent,
      0,
      0,
      0,
      _wagerSize,
      _wagerIds.current()
    );

    // add to _userWagers for both users, & _allWagers
    _userWagers[msg.sender].push(_wagerIds.current());
    _userWagers[_opponent].push(_wagerIds.current());

    _allWagers[_wagerIds.current()] = _newWager;

    emit wagerCreated(msg.sender, _opponent, _wagerSize, _description, _wagerIds.current());

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


  function provideWagerResponse(uint _wagerId, uint8 _response) public {
    Wager storage _wager = _allWagers[_wagerId];
    require(_wager.address1 == msg.sender, "Forbidden Responder");
    require(_wager.status == 0, "Response already recorded");
    require(_response == 1 || _response == 2, "Forbidden Response");

    if (_response == 2) {
      require(IERC20(wantToken).allowance(msg.sender, address(this)) >= _wager.wagerSize, "Insufficient allowance");
      require(IERC20(wantToken).transferFrom(msg.sender, address(this), _wager.wagerSize), "Match stake transfer failed");
    } else {
      require(IERC20(wantToken).transfer(_wager.address0, _wager.wagerSize), "Return stake transfer failed");
    }

    _wager.status = _response;
  }

  function provideWagerVerdict(uint _wagerId, uint8 _verdict) public {
    Wager storage _wager = _allWagers[_wagerId];
    require(_wager.address0 == msg.sender || _wager.address1 == msg.sender, "Forbidden Responder");
    require(_verdict == 1 || _verdict == 2, "Forbidden Verdict");

    if (_wager.address0 == msg.sender) {
      require(_wager.address0Verdict == 0, "Verdict already recorded");
      _wager.address0Verdict = _verdict;

    } else {
      require(_wager.address1Verdict == 0, "Verdict already recorded");
      _wager.address1Verdict = _verdict;

    }

    // if both verdicts are present, pay out the wager accordingly
    if (_wager.address0Verdict != 0 && _wager.address1Verdict != 0) {
      _wager.status = 3;

      if (_wager.address0Verdict == _wager.address1Verdict) {
        // disputed verdict, platform takes 100% of the wager stakes as punishment
        require(IERC20(wantToken).transfer(_deployer, _wager.wagerSize * 2), "Fee transfer failed");

      } else {
        // winner agreed - pay out winner minus a small fee
        require(IERC20(wantToken).transfer(_wager.address0Verdict == 2 ? _wager.address0 : _wager.address1, _wager.wagerSize*2 - _wager.wagerSize/100), "Payout transfer failed");
        require(IERC20(wantToken).transfer(_deployer, _wager.wagerSize / 100), "Fee transfer failed");
        
      }
    }

  }


  // NICKNAMES ================================================================

  function setNickname(string calldata _nickname) external {
    _playerNicknames[msg.sender] = _nickname;
  }

  function getNickname(address _selectedAddress) public view returns (string memory) {
    return _playerNicknames[_selectedAddress];
  }

}
