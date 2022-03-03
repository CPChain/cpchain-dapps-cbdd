// Deploy Cpchain-dapps-cbdd
var cbdd = artifacts.require("./CBDD.sol");
var controller = artifacts.require('./Controller.sol')

module.exports = function(deployer) {
    deployer.deploy(cbdd).then(async ()=>{
        const cbddIns = await cbdd.deployed()
        // deploy controller
        await deployer.deploy(controller, cbddIns.address);
    });
};
