# (X) Twitter
A Twitter (X) smart contract.

## Features

1. Send a Tweet
2. Reply to a Tweet
3. Like a Tweet
4. Tip a Tweet
5. Update Profile
6. Follow a User
7. Unfollow a User
8. Report a Tweet
9. Get Tweet
10. Get Replies
11. Get Following
12. Get Reports
13. Remove Follower
14. Remove Following

## Build Contract

```shell
$ forge b
```

## Running Test

```shell
$ forge t
```
### Deploy & Verify

```shell
$ forge create --rpc-url https://rpc.sepolia-api.lisk.com --etherscan-api-key 123 --verify --verifier blockscout --verifier-url https://sepolia-blockscout.lisk.com/api --private-key <private-key> src/<contract-file>:<contract-name>
```

Example:

```shell
$ forge create --rpc-url https://rpc.sepolia-api.lisk.com --etherscan-api-key 123 --verify --verifier blockscout --verifier-url https://sepolia-blockscout.lisk.com/api --private-key <your-private-key> src/Twitter.sol:Twitter
```

### Deployed & Verified Contract Addresses

```shell
Twitter: 0xB70b5532324315C809e4479725a1D9dAa51A7E54

## Explorer Link
- Link to Twitter deployed smart contract on Lisk Testnet Explorer: [https://sepolia-blockscout.lisk.com/address/0xB70b5532324315C809e4479725a1D9dAa51A7E54](https://sepolia-blockscout.lisk.com/address/0xB70b5532324315C809e4479725a1D9dAa51A7E54)
