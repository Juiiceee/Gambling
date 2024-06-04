// SPDX-License-Identifier:MIT

pragma solidity ^0.8.2;

contract Gambling{
	mapping(address => uint) public nbTicketsByAddress;
	uint public nbTickets;
	uint public salut;
	constructor (uint oui) {
		salut = oui;
	}
}
