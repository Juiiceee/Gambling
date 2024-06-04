// SPDX-License-Identifier:MIT

pragma solidity ^0.8.2;

contract Gambling{
	mapping(address => uint) private _nbTicketsByAddress;

	uint private _nbTickets;
	uint private _amount;
	address private _owner;
	bool private _isClosed;
	uint private _percentage;
	address private _winner;

	address[] private _indexToAddress;

	constructor (uint amount, uint percentage) {
		require(percentage <= 200, "Percentage is hight");
		setAmount(amount * 1 ether);
		setPercentage(percentage);
		_owner = msg.sender;
	}

	modifier onlyOwner {
		require(getOwner() == msg.sender, "You aren't the owner");
		_;
	}

	modifier onlyOpen {
		require(getIsClosed() == false, "Closed printing");
		_;
	}

	modifier onlySameAmount {
		require(getAmount() == msg.value, "Not same amount");
		_;
	}

	function getTicket() public payable onlySameAmount onlyOpen {
		setNbTickets(getNbTickets() + 1);
		setIndexToAddress(msg.sender);
	}

	function tr() public view returns(uint)
	{
		return (address(this).balance * (getPercentage() / 10));
	}

	function closingPrints() public onlyOwner onlyOpen {
		setIsClosed(true);
		setWinner(getIndexToAddress(getRandomNumber(getNbTickets())));
		payable(msg.sender).transfer((address(this).balance * getPercentage()) / 1000);
		payable(getWinner()).transfer(address(this).balance);
	}

	function getRandomNumber(uint limit) public view returns (uint) {
		uint randomHash = uint(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp, msg.sender)));
		return randomHash % limit;
	}

	function getNbTickets() public view returns (uint) {
		return _nbTickets;
	}

	function setNbTickets(uint nbTickets) private {
		_nbTickets = nbTickets;
	}

	function getAmount() public view returns (uint) {
		return _amount;
	}

	function setAmount(uint amount) private {
		_amount = amount;
	}

	function getOwner() public view returns (address) {
		return _owner;
	}

	function getIsClosed() public view returns (bool) {
		return _isClosed;
	}

	function setIsClosed(bool closed) private {
		_isClosed = closed;
	}

	function getNbTicketsByAddress(address addr) public view returns (uint) {
		return _nbTicketsByAddress[addr];
	}

	function setNbTicketsByAddress(address addr, uint nbTickets) private {
		_nbTicketsByAddress[addr] = nbTickets;
	}
	
	function getIndexToAddress(uint index) public view returns (address) {
		require(index < _indexToAddress.length, "Invalid index");
		return _indexToAddress[index];
	}

	function setIndexToAddress(address addr) private {
		_indexToAddress.push(addr);
	}

	function getPercentage() public view returns (uint) {
		return _percentage;
	}
	
	function setPercentage(uint percentage) private {
		_percentage = percentage;
	}

	function getWinner() public view returns (address) {
		return _winner;
	}

	function setWinner(address winner) private {
		_winner = winner;
	}
}
