// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract SimpleMultiSig {
    address[] public owners;
    uint256 public requiredApprovals;

    struct Transaction {
        address to;
        uint256 value;
        bytes data;
        bool executed;
        uint256 approvals;
    }

    Transaction[] public transactions;
    mapping(address => mapping(uint256 => bool)) public approved;

    constructor(address[] memory _owners, uint256 _requiredApprovalsForTx) {
        require(_owners.length > 0, "Owners required");
        require(
            _requiredApprovalsForTx > 0 && _requiredApprovalsForTx <= _owners.length,
            "Invalid number of required approvals"
        );
        owners = _owners;
        requiredApprovals = _requiredApprovalsForTx;
    }

    modifier onlyOwner() {
        bool isOwner = false;
        for (uint256 i = 0; i < owners.length; i++) {
            if (msg.sender == owners[i]) {
                isOwner = true;
                break;
            }
        }
        require(isOwner, "Not owner");
        _;
    }

    function submitTransaction(
        address to,
        uint256 value,
        bytes memory data
    ) public onlyOwner {
        transactions.push(
            Transaction({
                to: to,
                value: value,
                data: data,
                executed: false,
                approvals: 0
            })
        );
    }

    function approveTransaction(uint256 txIndex) public onlyOwner {
        Transaction storage transaction = transactions[txIndex];
        require(!transaction.executed, "Transaction already executed");
        require(!approved[msg.sender][txIndex], "Transaction already approved");

        approved[msg.sender][txIndex] = true;
        transaction.approvals += 1;

        if (transaction.approvals >= requiredApprovals) {
            executeTransaction(txIndex);
        }
    }

    function executeTransaction(uint256 txIndex) public onlyOwner {
        Transaction storage transaction = transactions[txIndex];
        require(transaction.approvals >= requiredApprovals, "Not enough approvals");
        require(!transaction.executed, "Transaction already executed");

        transaction.executed = true;
        (bool success, ) = transaction.to.call{value: transaction.value}(transaction.data);
        require(success, "Transaction failed");
    }

    receive() external payable {}
}
