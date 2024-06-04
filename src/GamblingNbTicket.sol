// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {Gambling} from "./Gambling.sol";

contract GamblingNbTicket is Gambling {
	uint256 private _nbTicketsMin;

	constructor(uint256 amount, uint256 percentage, uint256 nbTicketsMin) Gambling(amount, percentage) {
		_nbTicketsMin = nbTicketsMin;
	}

	function getTicket() public payable override onlySameAmount onlyOpen {
		setNbTickets(getNbTickets() + 1);
		setIndexToAddress(msg.sender);
		if (getNbTickets() == getNbTicketsMin()) {
			closingPrints();
		}
	}

	function getNbTicketsMin() public view returns (uint256) {
		return _nbTicketsMin;
	}

	function setNbTicketsMin(uint256 nbTicketsMin) internal {
		_nbTicketsMin = nbTicketsMin;
	}
}
