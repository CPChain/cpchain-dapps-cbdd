const cbdd = artifacts.require("cbdd");

contract("cbdd", (accounts) => {
    it("Action yield", async () => {
        const instance = await cbdd.deployed()
        const name = await instance.name()
        console.log(name)
    })
})
