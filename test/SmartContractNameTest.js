// OwnedTokenTests.js
//
// 1. Should allow only the owner to change the Token name.
// 2. Should transfer tokens to anyone except Token's current owner.
// 3. Should store the token owner's data
// 4. Should make the contract deployer the owner

const YourContractName = artifacts.require('./YourContractName.sol');
const _ = '        ';


contract('YourContractName', async function (accounts) {
  let token;

  before(done => {
    (async () => {
      try {
        // TODO: All setup steps belong here, including contract deployment.
        token = await YourContractName.new();
        var tx = await web3.eth.getTransactionReceipt(token.transactionHash);
        totalGas = totalGas.plus(tx.gasUsed);
        console.log(_ + tx.gasUsed + ' - Deploy YourContractName');
        token = await YourContractName.deployed();

        // Output how much gas was spent
        console.log(_ + '-----------------------');
        console.log(_ + totalGas.toFormat(0) + ' - Total Gas');
        done();
      }
      catch (error) {
        console.error(error);
        done(false);
      }
    })();
  });

  describe('YourContractName.sol', function () {
    it('Should always pass this canary test', async () => {
      assert(true === true, 'this is true');
    });

    it("Should make the contract deployer the owner", async () => {
      let instance = await YourContractName.deployed();
      // TODO: Write the code here to call a contract function
    });

    it("Should store the token owner's data", async () => {
      let instance = await YourContractName.deployed();
      // TODO: Write the code here to call a contract function
    });
 });
});
