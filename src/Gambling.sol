// SPDX-License-Identifier:MIT

pragma solidity ^0.8.2;

contract Gambling {
    mapping(address => uint256) private _nbTicketsByAddress;

    uint256 private _nbTickets;
    uint256 private _amount;
    address private _owner;
    bool private _isClosed;
    uint256 private _percentage;
    address private _winner;

    address[] private _indexToAddress;

    constructor(uint256 amount, uint256 percentage) {
        require(percentage <= 200, "Percentage is hight");
        setAmount(amount * 1 ether);
        setPercentage(percentage);
        _owner = msg.sender;
    }

    modifier onlyOwner() {
        require(getOwner() == msg.sender, "You aren't the owner");
        _;
    }

    modifier onlyOpen() {
        require(getIsClosed() == false, "Closed printing");
        _;
    }

    modifier onlySameAmount() {
        require(getAmount() == msg.value, "Not same amount");
        _;
    }

    function getTicket() public payable virtual onlySameAmount onlyOpen {
        setNbTickets(getNbTickets() + 1);
        setIndexToAddress(msg.sender);
    }

    function closingPrints() public onlyOwner onlyOpen {
        setIsClosed(true);
        setWinner(getIndexToAddress(getRandomNumber(getNbTickets())));
        payable(msg.sender).transfer((address(this).balance * getPercentage()) / 1000);
        payable(getWinner()).transfer(address(this).balance);
    }

    function getRandomNumber(uint256 limit) public view returns (uint256) {
        uint256 randomHash =
            uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp, msg.sender)));
        return randomHash % limit;
    }

    function getNbTickets() public view returns (uint256) {
        return _nbTickets;
    }

    function setNbTickets(uint256 nbTickets) internal {
        _nbTickets = nbTickets;
    }

    function getAmount() public view returns (uint256) {
        return _amount;
    }

    function setAmount(uint256 amount) internal {
        _amount = amount;
    }

    function getOwner() public view returns (address) {
        return _owner;
    }

    function getIsClosed() public view returns (bool) {
        return _isClosed;
    }

    function setIsClosed(bool closed) internal {
        _isClosed = closed;
    }

    function getNbTicketsByAddress(address addr) public view returns (uint256) {
        return _nbTicketsByAddress[addr];
    }

    function setNbTicketsByAddress(address addr, uint256 nbTickets) internal {
        _nbTicketsByAddress[addr] = nbTickets;
    }

    function getIndexToAddress(uint256 index) public view returns (address) {
        require(index < _indexToAddress.length, "Invalid index");
        return _indexToAddress[index];
    }

    function setIndexToAddress(address addr) internal {
        _indexToAddress.push(addr);
    }

    function getPercentage() public view returns (uint256) {
        return _percentage;
    }

    function setPercentage(uint256 percentage) internal {
        _percentage = percentage;
    }

    function getWinner() public view returns (address) {
        return _winner;
    }

    function setWinner(address winner) internal {
        _winner = winner;
    }
}
