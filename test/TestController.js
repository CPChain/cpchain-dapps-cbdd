const controller = artifacts.require("controller");
const cbdd = artifacts.require("cbdd");
const utils = require('./utils')

contract("controller", (accounts) => {
    it("Init controller", async () => {
        const instance = await controller.deployed()
        const erc20 = await cbdd.deployed()
        console.log(instance.address)
        assert.equal(await erc20.balanceOf(accounts[0]), 0)
        await instance.yieldTest(accounts[0])
        assert.equal(await erc20.balanceOf(accounts[0]), utils.cpc(2))
    })
})
