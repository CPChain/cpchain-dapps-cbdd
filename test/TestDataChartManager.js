const controllerContract = artifacts.require("controller");
const cbddController = artifacts.require("cbdd");
const dataSourceContract = artifacts.require("dataSourceManager");
const dataChartContract = artifacts.require("dataChartManager");
const utils = require('./utils')

contract("Data Chart", async (accounts) => {
    it("Create data chart", async () => {
        const controller = await controllerContract.deployed()
        const dataSource = await dataSourceContract.deployed()
        const dataChart = await dataChartContract.deployed()
        const cbdd = await cbddController.deployed()

        assert.equal(await cbdd.balanceOf(accounts[0]), 0)
        await controller.createDataSource("name", "desc", "0.1", "http://url")

        assert.equal(await cbdd.balanceOf(accounts[0]), utils.cpc(2))
        
        // create data chart
        await controller.createDataChart("chart", 1, "desc", "type", "data")

        assert.equal(await cbdd.balanceOf(accounts[0]), utils.cpc(4))
        assert.equal(await dataChart.existsID(1), true)
        assert.equal(await dataChart.existsID(2), false)
        assert.equal(await dataChart.existsName("chart"), true)
        assert.equal(await dataChart.existsName("chart1"), false)

        // create a chart without exists data source
        try {
          await controller.createDataChart("chart2", 2, "desc", "type", "data")
          assert.fail()
        } catch(error) {
          assert.ok(error.toString().includes("Do not find the data source"))
        }

        // create a chart with exists name
        try {
          await controller.createDataChart("chart", 1, "desc", "type", "data")
          assert.fail()
        } catch(error) {
          assert.ok(error.toString().includes("Name of element have been exists!"))
        }
    })
})
