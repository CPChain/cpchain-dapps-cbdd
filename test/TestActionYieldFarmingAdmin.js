const cbdd = artifacts.require("cbdd");
const truffleAssert = require('truffle-assertions');
const utils = require('./utils.js')

contract("action yield farming admin", (accounts) => {
    it("Init", async () => {
        const instance = await cbdd.deployed()
        assert.equal(await instance.getCurrentRewardsOfAllAction(), 0)
        assert.equal(await instance.totalSupply(), 0)
    })
    it("set action reward", async ()=> {
      const instance = await cbdd.deployed()
      assert.equal(await instance.getActionReward(0), utils.cpc(2))
      
      const tx = await instance.setActionReward(0, 1)
      truffleAssert.eventEmitted(tx, 'SetActionRewardEvent', (e) => {
        return e.reward == 1 && e.action_id == 0
      });

      assert.equal(await instance.getActionReward(0), 1)
    })
    it("set action max yield times", async ()=> {
      const instance = await cbdd.deployed()
      assert.equal(await instance.getMaxYieldTimesOfAction(0), 10000)

      const tx = await instance.setActionMaxYieldTimes(0, 3)
      truffleAssert.eventEmitted(tx, 'SetActionMaxYieldTimesEvent', (e) => {
        return e.max_times == 3 && e.action_id == 0
      });

      assert.equal(await instance.getMaxYieldTimesOfAction(0), 3)
    })
    it("set without owner", async () => {
      const instance = await cbdd.deployed()
      try {
        await instance.setActionReward(0, 1, {from: accounts[1]})
        assert.fail()
      } catch(error) {
        assert.ok(error.toString())
      }
      try {
        await instance.setActionMaxYieldTimes(0, 1, {from: accounts[1]})
        assert.fail()
      } catch(error) {
        assert.ok(error.toString())
      }
    })
})
