const cbdd = artifacts.require("cbdd");

contract("cbdd", (accounts) => {
    it("Action yield", async () => {
        const instance = await cbdd.deployed()
        const rewards = await instance.getMaxRewardsOfAllAction()

        assert.equal(await instance.getCurrentRewardsOfAllAction(), 0)

        console.log(web3.utils.fromWei(rewards))
    })
})
