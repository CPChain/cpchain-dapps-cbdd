const ControllerIniter = artifacts.require("Cpchain-dapps-cbdd");

contract("Cpchain-dapps-cbdd", (accounts) => {
    it("Greet", async () => {
    const instance = await Cpchain-dapps-cbdd.deployed()
    const text = await instance.greet()
    console.log(text)
    })
})
