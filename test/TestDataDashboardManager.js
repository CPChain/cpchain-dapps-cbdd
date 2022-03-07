const controllerContract = artifacts.require("controller");
const cbddController = artifacts.require("cbdd");
const dataSourceContract = artifacts.require("dataSourceManager");
const dataChartContract = artifacts.require("dataChartManager");
const dataDashboardContract = artifacts.require("dataChartManager");
const utils = require('./utils')

contract("Data Dashboard", async (accounts) => {
    it("Create data dashboard", async () => {
        const controller = await controllerContract.deployed()
        const dataDashboard = await dataDashboardContract.deployed()
        const cbdd = await cbddController.deployed()

        assert.equal(await cbdd.balanceOf(accounts[0]), 0)
        await controller.createDataSource("name", "desc", "0.1", "http://url")

        assert.equal(await cbdd.balanceOf(accounts[0]), utils.cpc(2))
        
        // create data chart
        await controller.createDataChart("chart", 1, "desc", "type", "data")

        assert.equal(await cbdd.balanceOf(accounts[0]), utils.cpc(4))
    
        // create data dashboard
        await controller.createDataDashboard("dashboard", [1], "desc", "data")

        assert.equal(await cbdd.balanceOf(accounts[0]), utils.cpc(6))
        assert.equal(await dataDashboard.existsID(1), true)
        assert.equal(await dataDashboard.existsID(2), false)
        assert.equal(await dataDashboard.existsName("chart"), true)
        assert.equal(await dataDashboard.existsName("chart1"), false)

        // create a dashboard without exists data chart
        try {
          await controller.createDataDashboard("dashboard2", [1,2], "desc", "data")
          assert.fail()
        } catch(error) {
          assert.ok(error.toString().includes("Do not find the data chart"))
        }

        // create a dashboard with exists name
        try {
          await controller.createDataDashboard("dashboard", [1], "desc", "data")
          assert.fail()
        } catch(error) {
          assert.ok(error.toString().includes("Name of element have been exists!"))
        }
    })
})
