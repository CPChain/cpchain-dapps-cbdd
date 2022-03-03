const controller = artifacts.require("controller");
const cbdd = artifacts.require("cbdd");
const utils = require('./utils')

contract("controller", (accounts) => {
    it("Create data source", async () => {
        const instance = await controller.deployed()
        const erc20 = await cbdd.deployed()
        assert.equal(await erc20.balanceOf(accounts[0]), 0)
        await instance.createDataSource("name", "desc", "0.1", "http://url")
        assert.equal(await erc20.balanceOf(accounts[0]), utils.cpc(2))
        await instance.createDataSource("name", "desc", "0.1", "http://url")
        await instance.createDataSource("name", "desc", "0.1", "http://url")
        assert.equal(await erc20.balanceOf(accounts[0]), utils.cpc(6))
    })
})
