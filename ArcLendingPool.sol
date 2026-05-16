// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ArcLendingPool {
    IERC20 public immutable depositToken;     // User-ra jeta deposit kore interest pabe (e.g., Token0)
    IERC20 public immutable collateralToken;  // Zamanat hisebe jeta joma rakhbe (e.g., Token1)

    // Collateral Ratio: 75%. Tarmane $100 er asset joma rakhle max $75 dhar neya jabe.
    uint public constant COLLATERAL_RATIO = 75; 
    uint public constant INTEREST_RATE = 5;     // Simple 5% standard interest rate for borrowing

    mapping(address => uint) public depositedBalance;
    mapping(address => uint) public collateralBalance;
    mapping(address => uint) public borrowedBalance;

    event Deposited(address indexed user, uint amount);
    event CollateralAdded(address indexed user, uint amount);
    event Borrowed(address indexed user, uint amount);
    event Repayed(address indexed user, uint amount);

    constructor(address _depositToken, address _collateralToken) {
        depositToken = IERC20(_depositToken);
        collateralToken = IERC20(_collateralToken);
    }

    // 1. Lender-ra ekhane token deposit korbe pool liquid rakhte
    function deposit(uint _amount) external {
        require(_amount > 0, "Amount must be greater than 0");
        depositToken.transferFrom(msg.sender, address(this), _amount);
        depositedBalance[msg.sender] += _amount;
        emit Deposited(msg.sender, _amount);
    }

    // 2. Borrower-ra dhar neyar age ekhane zamanat (Collateral) joma rakhbe
    function addCollateral(uint _amount) external {
        require(_amount > 0, "Collateral must be greater than 0");
        collateralToken.transferFrom(msg.sender, address(this), _amount);
        collateralBalance[msg.sender] += _amount;
        emit CollateralAdded(msg.sender, _amount);
    }

    // 3. Zamanat er upor vitti kore dhar (Borrow) neya
    function borrow(uint _borrowAmount) external {
        require(_borrowAmount > 0, "Borrow amount must be greater than 0");
        
        // Simple 1:1 price ratio assumption (EVM logic security check)
        uint maxBorrowAllowed = (collateralBalance[msg.sender] * COLLATERAL_RATIO) / 100;
        require(borrowedBalance[msg.sender] + _borrowAmount <= maxBorrowAllowed, "Insufficient collateral security");

        // System check pool-e porimano asset ache kina
        require(depositToken.balanceOf(address(this)) >= _borrowAmount, "Not enough liquidity in pool");

        borrowedBalance[msg.sender] += _borrowAmount;
        depositToken.transfer(msg.sender, _borrowAmount);

        emit Borrowed(msg.sender, _borrowAmount);
    }

    // 4. Dhar porishodh kora (Repay) ebong asset mukto kora
    function repay(uint _repayAmount) external {
        require(_repayAmount > 0, "Repay amount must be greater than 0");
        require(borrowedBalance[msg.sender] >= _repayAmount, "Repaying more than borrowed");

        // Principal + calculated 5% interest math implementation
        uint interestFee = (_repayAmount * INTEREST_RATE) / 100;
        uint totalToPay = _repayAmount + interestFee;

        depositToken.transferFrom(msg.sender, address(this), totalToPay);
        borrowedBalance[msg.sender] -= _repayAmount;

        emit Repayed(msg.sender, _repayAmount);
    }
}
