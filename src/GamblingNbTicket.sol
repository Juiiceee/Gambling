// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {Gambling} from "./Gambling.sol";

contract GamblingNbTicket is Gambling {
	constructor(uint256 amount, uint256 percentage) Gambling(amount, percentage) {}

	
}
