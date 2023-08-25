const UserStorage = artifacts.require("UserStorage");
const Proxy = artifacts.require("Proxy");

module.exports = async function (deployer, network, accounts) {
  const [deployerAccount] = accounts;


  await deployer.deploy(UserStorage);
  const userStorageInstance = await UserStorage.deployed();

  console.log("UserStorage deployed to:", userStorageInstance.address);

  await deployer.deploy(Proxy, userStorageInstance.address, { from: deployerAccount });
  const proxyInstance = await Proxy.deployed();

  console.log("Proxy deployed to:", proxyInstance.address);
};
