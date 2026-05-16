// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

contract ArcFractionalNFT is ERC20, ERC721Holder {
    IERC721 public immutable nftCollection;
    uint public immutable nftId;
    
    address public immutable nftOwner;
    bool public isFractionalized;
    bool public isRedemed;

    uint public fixedShareSupply; // Total fractions to mint (e.g., 10,000 shares)

    event NFTFractionalized(address indexed owner, uint totalShares);
    event NFTRedeemed(address indexed redeemer);

    // Initial setup with Token Name: "Arc NFT Share" and Symbol: "aNFT"
    constructor(address _nftCollection, uint _nftId) ERC20("Arc NFT Share", "aNFT") {
        nftCollection = IERC721(_nftCollection);
        nftId = _nftId;
        nftOwner = msg.sender;
    }

    // 1. Lock the NFT and Mint Fractional ERC-20 Tokens
    function fractionalize(uint _shareSupply) external {
        require(msg.sender == nftOwner, "Only NFT owner can fractionalize");
        require(!isFractionalized, "Already fractionalized");
        require(_shareSupply > 0, "Shares must be greater than 0");

        fixedShareSupply = _shareSupply * 1e18; // Scale with ERC20 decimals

        // Contract addresses are safe to hold the NFT
        nftCollection.safeTransferFrom(msg.sender, address(this), nftId);

        // Mint standard ERC-20 fractions directly to the owner
        _mint(msg.sender, fixedShareSupply);
        isFractionalized = true;

        emit NFTFractionalized(msg.sender, fixedShareSupply);
    }

    // 2. Buyback/Redeem full NFT by returning all fraction shares
    function redeemNFT() external {
        require(isFractionalized, "NFT is not locked yet");
        require(!isRedemed, "Already redeemed");
        
        // Caller must hold all issued fractional tokens to unlock the underlying NFT
        require(balanceOf(msg.sender) == fixedShareSupply, "You must own 100% of fractional shares");

        // Burn shares inside the contract logic
        _burn(msg.sender, fixedShareSupply);
        isRedemed = true;

        // Return original NFT back to the controller
        nftCollection.safeTransferFrom(address(this), msg.sender, nftId);

        emit NFTRedeemed(msg.sender);
    }
}
