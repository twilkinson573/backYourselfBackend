//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Wager {

  struct LotteryTicketMeta {
    address address0;
    address address1;
    uint8 address0Verdict; // null == no verdict given yet, 0 == 'I lost' verdict, 1 == 'I won' verdict
    uint8 address1Verdict;
    uint depositSize;
    uint depositDate;
  }


  constructor() {
  }

}
