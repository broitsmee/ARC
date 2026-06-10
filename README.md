# ARC Decentralized Ecosystem

Welcome to the **ARC Decentralized Ecosystem**, a comprehensive suite of advanced smart contracts powering next-generation Web3 protocols. This repository contains the production-ready source code for a custom Automated Market Maker (AMM) DEX, a Liquidity Provider (LP) Staking Farm, a Collateralized Lending Pool, and a DAO Governance Protocol, alongside Fractional NFT tokenization mechanics.

All contracts are written in Solidity (`^0.8.20`) utilizing standard OpenZeppelin libraries and are optimized for secure compilation and deployment on EVM-compatible networks.

---

## 🚀 Deployed Contract Addresses (Arc Network Testnet)

The entire ecosystem has been successfully compiled and deployed live on the **Arc Network Testnet**. Below are the official smart contract tracking hashes:

| Contract Name | Deployed Contract Address |
| :--- | :--- |
| **MockToken (TokenA)** | `0x6BcC63FF3FFbA52A1762B34Bf5DeA21f84331837` |
| **MockToken (TokenB)** | `0xB357871b63B96A8EAb5b796ED4B9695669fA2e7` |
| **ArcTestnetDEX** | `0x4C974B1DAac51F94f7eEcA61eEfb889Ed8a7bC3B` |
| **ArcLendingPool** | `0xB08ed23C2Cc566b1932e7A7254d88DE1c9C212F7` |
| **ArcLPTakingFarm** | `0xe8c6D1cbfdd17E8595B2eCb3C6933b1157774280` |
| **ArcGovernanceDAO** | `0x9832244C1DABe3646f0B6F6f4f75Fd7be1F792D1` |
| **MockNFT** | `0x767ec170458BcC15B1aE705f0273396715E0E467` |
| **ArcFractionalNFT** | `0xb58877715Fe39Ef3aDe6c4F39982F5592683De03` |

---

## 🛠️ Core Ecosystem Modules

### 1. Automated Market Maker DEX (`ArcTestnetDEX.sol`)
A custom Decentralized Exchange implementing the standard Constant Product Market Maker formula ($x \times y = k$).
* **Liquidity Provision:** Allows users to pool token pairs (`token0` and `token1`) to provision trade liquidity, dynamic price calculations, and mint internal tracking shares.
* **Automated Swaps:** Enables instant token-to-token swaps backed by automated reserve updates.

### 2. LP Staking Farm (`ArcLPTakingFarm.sol`)
A yield-generating farming protocol designed to incentivize liquidity providers.
* **Yield Staking:** Users can lock their LP tokens generated from the DEX to earn passive continuous rewards.
* **Dynamic Reward Distribution:** Computes individual rewards per block using block-timestamp delta factors.

### 3. Collateralized Lending Pool (`ArcLendingPool.sol`)
A decentralized lending and borrowing framework modeled after over-collateralized isolated lending pools.
* **Liquidity Supply:** Lenders deposit base assets to provide pool depth and accrue structural interest.
* **Collateralized Borrows:** Borrowers deposit a dynamic secondary asset as security to safely borrow up to a **75% Collateral Ratio** of their holding value.

### 4. DAO Governance Protocol (`ArcGovernanceDAO.sol`)
A completely decentralized governance architecture empowering community token-holders.
* **Proposal Creation:** Users meeting a threshold requirement (min. 100 governance tokens) can propose protocol parameter upgrades.
* **Weighted Voting:** Implements democratic 1-Token-1-Vote weights over a set **3-day voting period**.

### 5. Fractional NFT Contract (`ArcFractionalNFT.sol`)
An asset-splitting protocol that bridges unique digital assets with ERC-20 utility markets.
* **NFT Locking:** Secures an incoming ERC-721 NFT collection item inside the vault logic.
* **Fractions Minting:** Generates proportional, fractionally liquid ERC-20 shares back to the original controller.

---

## 🛠️ Tech Stack & Dependencies

* **Language:** Solidity `^0.8.20`
* **Framework:** Remix IDE & OpenZeppelin Standard Libraries
* **Token Standards Supported:** ERC-20 (Fungible Tokens), ERC-721 (Non-Fungible Tokens), ERC-721Holder

---

## 🛡️ License

This project is licensed under the **MIT License**. Feel free to fork, test, and adapt the modules for custom protocol architectures.
