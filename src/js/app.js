App = {
  web3Provider: null,
  contracts: {},

  init: async function() {
    return await App.initWeb3();
  },

  initWeb3: async function() {
    // Modern dapp browsers...
    if (window.ethereum) {
      App.web3Provider = window.ethereum;
      try {
        // Request account access
        await window.ethereum.enable();
      } catch (error) {
        // User denied account access...
        console.error("User denied account access")
      }
    }
    // Legacy dapp browsers...
    else if (window.web3) {
      App.web3Provider = window.web3.currentProvider;
    }
    // If no injected web3 instance is detected, fall back to Ganache
    else {
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function() {
    $.getJSON('BlockchainMeOwnership.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var BlockchainMeArtifact = data;
      App.contracts.BlockchainMe = TruffleContract(BlockchainMeArtifact);

      // Set the provider for our contract
      App.contracts.BlockchainMe.setProvider(App.web3Provider);

      // Use our contract to get user's data
      return App.getUserData();
    });

    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '.btn-save', App.storeData);
    $(document).on('click', '.btn-update', App.changeData);
  },

  getUserData: function(data, account) {
    var blockchainMeInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];

      App.contracts.BlockchainMe.deployed().then(function(instance) {
        blockchainMeInstance = instance;

        return blockchainMeInstance.getDataByOwner(account);
      }).then(function(data) {
        var dataList = $('#dataList');
        var dataTemplate = $('#dataTemplate');

        if (data) {
          dataList.empty()
          for (i = 0; i < data.length; i ++) {
            let dataId = data[i]
            blockchainMeInstance.dataStore(data[i]).then((dataFromStore) => {
              dataTemplate.find('.btn-update').text(dataFromStore);
              dataTemplate.find('.btn-update').attr('data-id', dataId);

              dataList.append(dataTemplate.html());
            })
          }
        }

      }).catch(function(err) {
        console.log(err.message);
      });
    });
  },

  storeData: function(event) {
    event.preventDefault();

    const data = $('#dataInput').val();

    var blockchainMeInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];

      App.contracts.BlockchainMe.deployed().then(function(instance) {
        blockchainMeInstance = instance;

        // Execute storeData as a transaction by sending account
        return blockchainMeInstance.storeData(data, { from: account, value: web3.toWei("0.017", "ether") });
      }).then(function(result) {
        return App.getUserData();
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  },

  changeData: function(event) {
    event.preventDefault();

    const dataId = parseInt($(event.target).data('id'));
    const updatedData = $('#dataInput').val();

    var blockchainMeInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];

      App.contracts.BlockchainMe.deployed().then(function(instance) {
        blockchainMeInstance = instance;

        // Execute changeData as a transaction by sending account
        return blockchainMeInstance.changeData(dataId, updatedData, { from: account });
      }).then(function(result) {
        return App.getUserData();
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  }

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
