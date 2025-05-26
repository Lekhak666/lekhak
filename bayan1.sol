// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SatelliteRadar {

    address public owner;

    struct RadarScan {
        uint timestamp;
        string location;
        string dataHash; // IPFS hash or similar for scan data
    }

    RadarScan[] public scans;

    mapping(address => bool) public authorizedUsers;

    event ScanUploaded(uint indexed scanId, string location, string dataHash, uint timestamp);
    event UserAuthorized(address indexed user);
    event UserRevoked(address indexed user);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyAuthorized() {
        require(authorizedUsers[msg.sender], "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
        authorizedUsers[owner] = true;
    }

    function authorizeUser(address user) public onlyOwner {
        authorizedUsers[user] = true;
        emit UserAuthorized(user);
    }

    function revokeUser(address user) public onlyOwner {
        authorizedUsers[user] = false;
        emit UserRevoked(user);
    }

    function uploadScan(string memory location, string memory dataHash) public onlyAuthorized {
        scans.push(RadarScan(block.timestamp, location, dataHash));
        emit ScanUploaded(scans.length - 1, location, dataHash, block.timestamp);
    }

    function getScan(uint index) public view returns (uint, string memory, string memory) {
        RadarScan storage scan = scans[index];
        return (scan.timestamp, scan.location, scan.dataHash);
    }

    function totalScans() public view returns (uint) {
        return scans.length;
    }
}