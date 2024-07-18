// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract IDOToken is ERC20, Ownable {
    uint256 public idoPrice = 0.1 * 10 ** 18; // IDO价格
    uint256 public maxBuyAmount = 100 * 10 ** 18; // 最大购买量
    address public usdtAddress; // USDT代币地址

    mapping(address => bool) private isBuy; // 记录是否已购买

    constructor(address _usdtAddress) ERC20("MY Token", "MY") Ownable(msg.sender) {
        usdtAddress = _usdtAddress;
    }

    function buyToken(uint256 amount) public {
        require(!isBuy[msg.sender], "You have already bought!");
        require(amount <= maxBuyAmount, "Invalid amount");

        IERC20(usdtAddress).transferFrom(msg.sender, address(this), amount);

        uint256 buyNum = (amount * 10 ** 18) / idoPrice;
        isBuy[msg.sender] = true;

        _mint(msg.sender, buyNum);
    }

    function withdraw() public onlyOwner {
        uint256 bal = IERC20(usdtAddress).balanceOf(address(this));
        IERC20(usdtAddress).transfer(msg.sender, bal);
    }
}

