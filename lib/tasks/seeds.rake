# frozen_string_literal: true

namespace :seed do
  task tokens: :environment do
    Token.where(
      address: '0x0000000000000000000000000000000000000000',
      network: 'mainnet'
    ).first_or_create(code: 'ETH', standard: 'native')
    Token.where(
      address: '0x0000000000000000000000000000000000000000',
      network: 'ropsten'
    ).first_or_create(code: 'ETH', standard: 'native')
    Token.where(
      address: '0x0000000000000000000000000000000000000000',
      network: 'goerli'
    ).first_or_create(code: 'ETH', standard: 'native')

    Token.where(
      address: '0x6b175474e89094c44da98b954eedeac495271d0f',
      network: 'mainnet'
    ).first_or_create(code: 'DAI', standard: 'erc20')
    Token.where(
      address: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48',
      network: 'mainnet'
    ).first_or_create(code: 'USDC', standard: 'erc20', decimals: 6)
    Token.where(
      address: '0xdac17f958d2ee523a2206206994597c13d831ec7',
      network: 'mainnet'
    ).first_or_create(code: 'USDT', standard: 'erc20', decimals: 6)

    Token.where(
      address: '0x101848D5C5bBca18E6b4431eEdF6B95E9ADF82FA',
      network: 'ropsten'
    ).first_or_create(code: 'WEENUS', standard: 'erc20')
  end
end
