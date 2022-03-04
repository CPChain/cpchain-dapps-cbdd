const controllerContract = artifacts.require("controller");
const cbddController = artifacts.require("cbdd");
const dataSourceContract = artifacts.require("dataSourceManager");
const utils = require('./utils')

contract("controller", (accounts) => {
    it("Create data source", async () => {
        const controller = await controllerContract.deployed()
        const dataSource = await dataSourceContract.deployed()
        const cbdd = await cbddController.deployed()
        assert.equal(await cbdd.balanceOf(accounts[0]), 0)
        await controller.createDataSource("name", "desc", "0.1", "http://url")
        assert.equal(await cbdd.balanceOf(accounts[0]), utils.cpc(2))
        await controller.createDataSource("name2", "desc", "0.1", "http://url")
        await controller.createDataSource("name3", "desc", "0.1", "http://url")
        assert.equal(await cbdd.balanceOf(accounts[0]), utils.cpc(6))

        assert.equal(await dataSource.existsID(1), true)
        assert.equal(await dataSource.existsID(4), false)
        assert.equal(await dataSource.existsName("name"), true)
        assert.equal(await dataSource.existsName("name4"), false)
    })
    it("Update data source", async () => {
        const controller = await controllerContract.deployed()
        const dataSource = await dataSourceContract.deployed()
        const cbdd = await cbddController.deployed()

        await controller.updateDataSource(1, "name1", "desc1", "0.11", "http://url1")

        assert.equal(await dataSource.existsID(1), true)
        assert.equal(await dataSource.existsName("name"), false)
        assert.equal(await dataSource.existsName("name1"), true)
        assert.equal(await cbdd.balanceOf(accounts[0]), utils.cpc(6))
        
        const ds = await dataSource.getDataSource(1)
        assert.equal(ds.sender, accounts[0]);
        assert.equal(ds.name, "name1");
        assert.equal(ds.desc, "desc1");
        assert.equal(ds.version, "0.11");
        assert.equal(ds.url, "http://url1");
    })
    it("Like data source", async () => {
        const controller = await controllerContract.deployed()
        const dataSource = await dataSourceContract.deployed()
        const cbdd = await cbddController.deployed()

        assert.equal(await cbdd.balanceOf(accounts[1]), utils.cpc(0))

        // like
        await controller.likeDataSource(1, true, {from: accounts[1]})

        assert.equal(await cbdd.balanceOf(accounts[0]), utils.cpc(7))
        assert.equal(await cbdd.balanceOf(accounts[1]), utils.cpc(1))
        assert.equal(await dataSource.isLiked(1, accounts[1]), true);
        assert.equal(await dataSource.isLiked(1, accounts[0]), false);
    })
    it("Cancel like data source", async () => {
        const controller = await controllerContract.deployed()
        const dataSource = await dataSourceContract.deployed()
        const cbdd = await cbddController.deployed()

        await controller.likeDataSource(1, false, {from: accounts[1]})

        assert.equal(await cbdd.balanceOf(accounts[1]), utils.cpc(1))
        assert.equal(await dataSource.isLiked(1, accounts[1]), false);
        assert.equal(await dataSource.isDisliked(1, accounts[1]), false);
    })
    it("Dislike data source", async () => {
        const controller = await controllerContract.deployed()
        const dataSource = await dataSourceContract.deployed()
        const cbdd = await cbddController.deployed()

        await controller.likeDataSource(1, false, {from: accounts[1]})

        assert.equal(await cbdd.balanceOf(accounts[1]), utils.cpc(1))
        assert.equal(await dataSource.isLiked(1, accounts[1]), false);
        assert.equal(await dataSource.isDisliked(1, accounts[1]), true);

        // dislike
        await controller.likeDataSource(2, false, {from: accounts[1]})
        assert.equal(await cbdd.balanceOf(accounts[1]), utils.cpc(1))
        assert.equal(await dataSource.isLiked(2, accounts[1]), false);
        assert.equal(await dataSource.isDisliked(2, accounts[1]), true);
    })
    it("Cancel dislike data source", async () => {
        const controller = await controllerContract.deployed()
        const dataSource = await dataSourceContract.deployed()
        const cbdd = await cbddController.deployed()

        await controller.likeDataSource(1, true, {from: accounts[1]})

        assert.equal(await cbdd.balanceOf(accounts[1]), utils.cpc(1))
        assert.equal(await dataSource.isLiked(1, accounts[1]), false);
        assert.equal(await dataSource.isDisliked(1, accounts[1]), false);
    })
    it("Delete data source", async ()=> {
        const controller = await controllerContract.deployed()
        const dataSource = await dataSourceContract.deployed()

        try {
            await controller.deleteDataSource(1, {from: accounts[1]})
            assert.fail()
        } catch(error) {
            assert.ok(error.toString().includes("Only the owner of this data source can call it"))
        }

        await controller.deleteDataSource(1, {from: accounts[0]})
        assert.equal(await dataSource.existsID(1), false)
        assert.equal(await dataSource.existsName("name1"), false)
    })
    it("Update the length of name", async ()=> {

    })
    it("Update the length of description", async ()=> {

    })
})
