## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge create Counter --rpc-url <your_rpc_url> --private-key <your_private_key>
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
$ forge script script/Counter.s.sol:CounterScript --rpc-url http://127.0.0.1:8545 --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

// using .env file
$ source .env 
$ echo $PRIVATE_KEY
$ forge script script/Counter.s.sol:CounterScript --rpc-url $RPC_URL --broadcast --private-key $PRIVATE_KEY 

// import hexadecimal private key into keystore
$ cast wallet import defaultKey --interactive
$ cast wallet list
$ forge script script/Counter.s.sol:CounterScript --rpc-url $RPC_URL --account defaultKey --sender 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266 --broadcast -vvvv
```

### Cast

```shell
$ cast <subcommand>

// interaction with smart contract functions
$ cast send 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "setNumber(uint256)" 157 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
$ cast send 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "increment()" 0 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
$ cast call 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "getNumber()"
$ cast --to-base 0x00000000000000000000000000000000000000000000000000000000000000a0 dec
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
