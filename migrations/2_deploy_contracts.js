var BlockchainMe = artifacts.require("BlockchainMeOwnership");

module.exports = function(deployer) {
  deployer.deploy(BlockchainMe);
};
