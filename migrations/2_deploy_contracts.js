// Deploy Cpchain-dapps-cbdd
var cbdd = artifacts.require("./CBDD.sol");
var controller = artifacts.require('./Controller.sol')
var dataSourceManager = artifacts.require('./DataSourceManager.sol')

module.exports = function(deployer) {
    deployer.deploy(cbdd).then(async ()=>{
        // CBDD token contract
        const cbddIns = await cbdd.deployed()

        // deploy DataManager contract
        const dataSourceManagerIns = await deployer.deploy(dataSourceManager)

        // deploy controller
        await deployer.deploy(controller, cbddIns.address, dataSourceManagerIns.address);
    });
};
