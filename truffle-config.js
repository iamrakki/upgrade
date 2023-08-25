const HDWalletProvider = require("@truffle/hdwallet-provider");
const mnemonic = "aae6757d640c565936fef7fb0aa53e9be9e397428406a35ec0008401d7a70c8d"; 
module.exports = {
  networks: {
    matic: {
      provider: () => new HDWalletProvider(mnemonic, 'https://polygon-mumbai.infura.io/v3/467cb109e77349eeb28914213aab1e0a'),
      network_id: 80001, 
      gas: 5500000,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true,
    },
  },

  compilers: {
    solc: {
      version: "0.8.0", 
      settings: {
        optimizer: {
          enabled: true,
          runs: 200,
        },
      },
    },
  },
};
