// Deploy Cpchain-dapps-cbdd
var cbdd = artifacts.require("./CBDD.sol");

module.exports = function(deployer) {
    deployer.deploy(cbdd);
};
