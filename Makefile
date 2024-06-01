-include .env
build:; forge build 
deploy-sepolia:
	forge script --legacy script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC_URL) --private-key $(WALLET_PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv 
test :; forge test
format :; forge fmt
snapshot :; forge snapshot