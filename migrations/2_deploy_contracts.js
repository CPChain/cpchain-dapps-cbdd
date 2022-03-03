// Deploy Cpchain-dapps-cbdd
var cbdd = artifacts.require("./CBDD.sol");
var controller = artifacts.require('./Controller.sol')
var dataManager = artifacts.require('./DataManager.sol')

module.exports = function(deployer) {
    deployer.deploy(cbdd).then(async ()=>{
        // CBDD token contract
        const cbddIns = await cbdd.deployed()

        // deploy DataManager contract
        const dataManagerIns = await deployer.deploy(dataManager)

        // deploy controller
        await deployer.deploy(controller, cbddIns.address, dataManagerIns.address);
    });
};
