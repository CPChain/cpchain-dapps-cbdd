// Deploy Cpchain-dapps-cbdd
var cbdd = artifacts.require("./CBDD.sol");
var controller = artifacts.require('./Controller.sol')
var dataSourceManager = artifacts.require('./DataSourceManager.sol')
var dataChartManager = artifacts.require('./DataChartManager.sol')
var dataDashboardManager = artifacts.require('./DataDashboardManager.sol')
var baseCommentManager = artifacts.require('./lib/BaseComment.sol')

module.exports = function(deployer) {
    deployer.deploy(cbdd).then(async ()=>{
        // CBDD token contract
        const cbddIns = await cbdd.deployed()

        // deploy DataSourceManager contract
        const dataSourceComment = await deployer.deploy(baseCommentManager)
        const dataSourceManagerIns = await deployer.deploy(dataSourceManager, dataSourceComment.address)

        // deploy DataChartManager contract
        const dataChartComment = await deployer.deploy(baseCommentManager)
        const dataChartManagerIns = await deployer.deploy(dataChartManager, dataSourceManagerIns.address, dataChartComment.address)

        // deploy DataDashboardManager contract
        const dataDashboardComment = await deployer.deploy(baseCommentManager)
        const dataDashboardIns = await deployer.deploy(dataDashboardManager, dataChartManagerIns.address, dataDashboardComment.address)

        // deploy controller
        await deployer.deploy(controller,
            cbddIns.address,
            dataSourceManagerIns.address,
            dataChartManagerIns.address,
            dataDashboardIns.address);
    });
};
