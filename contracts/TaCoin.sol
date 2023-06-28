//Trin Tether Token
// security-comments-tafittechtt@gmail.com
//coded-Tafit Tech Limited 
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.9 <0.8.21;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract TaCoin is ERC20Capped, ERC20Burnable {
    address payable public owner;
    uint256 public blockReward;
    constructor(uint256 cap, uint256 reward) ERC20("TaCoin", "TACO") ERC20Capped(cap* (10 ** decimals())) {
        owner = payable(msg.sender);
        _mint(owner, 36762000000*(10 ** decimals()));
        blockReward = reward * (10 ** decimals());
    }

    function _mint(address account, uint256 amount) internal virtual override(ERC20Capped,ERC20) {
        require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }


    function _mintMinerReward() internal {
        _mint(block.coinbase,blockReward);
    }

    function _beforeTokenTransfer(address from, address to, uint256 value) internal virtual override{
        if( from != address(0) && to != block.coinbase && block.coinbase != address(0)){
            _mintMinerReward();

        }
        super._beforeTokenTransfer(from,to,value);
    }

    function setBlockReward(uint256 reward) public onlyOwner {
        blockReward = reward * (10 ** decimals());

    }

    modifier onlyOwner{
        require(msg.sender == owner, "Only the Owner can call this function");
        _;
    }
    

    function _afterTransferWithdraw(uint256 amount, uint256 amtWithdrawn) internal virtual {
        amtWithdrawn = uint256( amount);
        
        if (amtWithdrawn >= 250000 *(10 **decimals())){
            _burn(msg.sender, amount);
        } else{
            _mintMinerReward();
        }
    } 
}