# TokenStaking

A decentralized token staking and yield generation system.

## Overview

TokenStaking is a blockchain-based platform that enables:
- Users to stake their tokens in a shared pool
- Automatic yield generation based on staking duration
- Fair distribution of yield based on stake proportion

## Features

- **Token Staking**: Secure staking of tokens in a managed pool
- **Yield Generation**: Automatic yield calculation over time
- **Proportional Distribution**: Yield distributed based on stake size
- **Treasury Management**: Controller oversight for system integrity

## Functions

- `bootstrap`: Initialize the system with a treasury controller
- `stake`: Stake tokens in the yield-generating pool
- `calculate-yield`: Calculate and distribute yield to the pool
- `unstake`: Allow stakers to withdraw their tokens plus earned yield

## Getting Started

1. Deploy the contract to your blockchain
2. Bootstrap the system with a trusted treasury controller
3. Users can begin staking their tokens in the pool
4. Periodically calculate yield to maintain accurate rewards

## Security

The system includes permission controls to ensure only authorized controllers can perform sensitive operations like yield calculation.