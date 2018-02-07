pragma solidity ^0.4.11;

contract Lockable {
    uint256 public creationTime;
    bool public lock;
    bool public tokenTransfer;
    address public owner;
    mapping(address => bool) public unlockaddress;
    mapping(address => bool) public lockaddress;

    event Locked(address lockaddress,bool status);
    event Unlocked(address unlockedaddress, bool status);

    modifier isTokenTransfer {
        // if token transfer is not allow
        if(!tokenTransfer) {
            require(unlockaddress[msg.sender]);
        }
        _;
    }

    modifier checkLock {
        if (lockaddress[msg.sender]) {
            throw;
        }
        _;
    }

    modifier isOwner {
        require(owner == msg.sender);
        _;
    }

    function Lockable() {
        creationTime = now;
        tokenTransfer = false;
        owner = msg.sender;
    }

    function lockAddress(address target, bool status)
    external
    isOwner
    {
        require(owner != target);
        lockaddress[target] = status;
        Locked(target, status);
    }

    function unlockAddress(address target, bool status)
    external
    isOwner
    {
        unlockaddress[target] = status;
        Unlocked(target, status);
    }
}