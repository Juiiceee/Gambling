// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {Gambling} from "./Gambling.sol";

contract GamblingCondition is Gambling {
	constructor (uint amount, uint percentage) Gambling(amount, percentage) {

	}
	
}