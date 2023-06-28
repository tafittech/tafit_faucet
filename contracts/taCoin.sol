//Trin Tether Token
// security-comments-tafittechtt@gmail.com
//coded-Tafit Tech Limited 
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.9 <0.8.21;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract taCoin is ERC20Capped, ERC20Burnable {


    uint256 public blockReward;
    using Address for address;
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    IERC20 public token;
    constructor(uint256 cap, uint256 reward, address, _token) ERC20("TaCoinr", "TAC0") ERC20Capped(10* (1000000000 ** decimals(2))) {
        token = IERC20(_token);
        blockReward = reward(0.0003 * (10 ** decimals(2)));
    }
    function balance() public view returns (uint256){
        return token.balanceOf(address(this));
    }
    function _mint(address account, uint256 amount) internal virtual override(ERC20Capped,ERC20) {
        require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }
    function deposit(uint256 amount) public {
        require(amount> 0, "amount cannot be 0");
        token.safeTransferFrom(msg.sender,address(this), amount);
        _mint(msg.sender, amount);
    }

    function _mintMinerReward() internal {
        _mint(block.coinbase,blockReward);
    }
    function withdraw(uint256 amount) public {
        _burn(msg.sender, amount);
        token.safeTransfer(msg.sender, amount);
    }
    

    function _beforeTokenTransfer(address from, address to, uint256 value) internal virtual override{
        if( from != address(0) && to != block.coinbase && block.coinbase != address(0)){
            _mintMinerReward();

        }
        super._beforeTokenTransfer(from,to,value);
    }

}