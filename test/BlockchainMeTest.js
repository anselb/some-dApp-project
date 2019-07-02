// BlockchainMeTest.js
//
// 1. Should always pass this canary test
// 2. Should make the contract deployer the owner
// 3. Should store the token owner's data
// 4. Should be able to use ERC721 methods

const BlockchainMe = artifacts.require('./BlockchainMeOwnership.sol');


contract('BlockchainMe', async function (accounts) {
  let token;

  before(done => {
    (async () => {
      try {
        // Deploy BlockchainMeOwnership.sol
        token = await BlockchainMe.new();

        // See how much gas was used
        var tx = await web3.eth.getTransactionReceipt(token.transactionHash);
        console.log('    Gas Used: ' + tx.gasUsed + ' - Deploy BlockchainMe');

        token = await BlockchainMe.deployed();

        done();
      }
      catch (error) {
        console.error(error);
        done(false);
      }
    })();
  });

  describe('BlockchainMe.sol', function () {
    it('Should always pass this canary test', async () => {
      assert(true === true, 'this is true');
    });

    it("Should make the contract deployer the owner", async () => {
      let instance = await BlockchainMe.deployed();
      let owner = await instance.owner();

      assert.equal(owner, accounts[0]);
    });

    it("Should store the token owner's data", async () => {
      let instance = await BlockchainMe.deployed();
      let rando = accounts[1];
      await instance.storeData("rando's name", { from: rando, value: web3.utils.toWei("0.017", "ether") })
      let newData = await instance.dataStore(0)

      assert.equal(newData, "rando's name");
    });

    it("Should be able to use ERC721 methods", async () => {
      let instance = await BlockchainMe.deployed();
      let rando = accounts[1];
      let balance = await instance.balanceOf(rando)

      assert.equal(balance, 1);

      let ownerOfZero = await instance.ownerOf(0)

      assert.equal(ownerOfZero, rando);
    });
 });
});
