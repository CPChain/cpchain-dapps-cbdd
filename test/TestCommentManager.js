const controllerContract = artifacts.require("controller");
const cbddController = artifacts.require("cbdd");
const dataSourceContract = artifacts.require("dataSourceManager");
const utils = require('./utils')

contract("controller", (accounts) => {
    it("Comment on a data source", async () => {
        const controller = await controllerContract.deployed()
        const dataSource = await dataSourceContract.deployed()
        const cbdd = await cbddController.deployed()
        await controller.createDataSource("name", "desc", "0.1", "http://url")
        await controller.createDataSource("name2", "desc", "0.1", "http://url")
        await controller.createDataSource("name3", "desc", "0.1", "http://url")
        assert.equal(await cbdd.balanceOf(accounts[0]), utils.cpc(6))

        // add comment
        


    })
})
