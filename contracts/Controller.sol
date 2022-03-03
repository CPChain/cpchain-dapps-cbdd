pragma solidity ^0.4.24;

import "@cpchain-tools/cpchain-dapps-utils/contracts/ownership/Claimable.sol";
import "@cpchain-tools/cpchain-dapps-utils/contracts/lifecycle/Enable.sol";
import "./interfaces/IController.sol";
import "./interfaces/IVersion.sol";
import "./interfaces/IControllerIniter.sol";
import "./interfaces/IActionYieldFarming.sol";
import "./lib/Actions.sol";

contract Controller is Claimable, Enable, IController {
    enum CONTRACTS {
        ADDRESS_VALIDATOR,
        DATA_MANAGER,
        TAG_MANAGER,
        COMMENT_MANAGER,
        CBDD_TOKEN
    }

    // CBDD ERC20 contract
    IActionYieldFarming cbdd;

    struct MyContract {
        address addr;
        uint version;
    }
    mapping(uint => MyContract) private my_contracts;

    constructor(address cbdd_addr) public {
        _setContract(CONTRACTS.CBDD_TOKEN, cbdd_addr);
    }

    modifier initedCBDD() {require(my_contracts[uint(CONTRACTS.CBDD_TOKEN)].addr != address(0x0)); _;}

    function _setContract(CONTRACTS code, address addr) private {
        require(addr != address(0x0), "Address can't be zero address");
        // The contract should be Version and ControllerIniter
        IVersion versionInstance = IVersion(addr);
        IControllerIniter initer = IControllerIniter(addr);

        if (my_contracts[uint(code)].addr != address(0x0)) {
            // validate version, the version should greater than current
            require(versionInstance.version() > my_contracts[uint(code)].version,
                "New version of contract should greater than current version");
        }
        // the contract should not has any controller inited it
        require(!initer.isInitedController(), "This contract have been inited by other controller");

        // init the contract
        initer.initController(address(this));

        // set this contract
        my_contracts[uint(code)].addr = addr;
        my_contracts[uint(code)].version = versionInstance.version();

        // set instances
        if (code == CONTRACTS.CBDD_TOKEN) {
            cbdd = IActionYieldFarming(addr);
            emit RegisterCBDDToken(my_contracts[uint(code)].version, addr);
        }
    }

    function registerAddressValidator(uint version, address contract_address) external {
        IVersion versionInstance = IVersion(contract_address);
        require(version == versionInstance.version(), "The version of the address is different from the one passed in");
    }

    function registerDataManager(uint version, address contract_address) external {
        IVersion versionInstance = IVersion(contract_address);
        require(version == versionInstance.version(), "The version of the address is different from the one passed in");
    }

    function registerTagManager(uint version, address contract_address) external {
        IVersion versionInstance = IVersion(contract_address);
        require(version == versionInstance.version(), "The version of the address is different from the one passed in");
    }

    function registerCommentManager(uint version, address contract_address) external {
        IVersion versionInstance = IVersion(contract_address);
        require(version == versionInstance.version(), "The version of the address is different from the one passed in");
    }

    function registerCBDDToken(uint version, address contract_address) external {
        IVersion versionInstance = IVersion(contract_address);
        require(version == versionInstance.version(), "The version of the address is different from the one passed in");
        _setContract(CONTRACTS.CBDD_TOKEN, contract_address);
    }

    function yieldTest(address recipient) external initedCBDD onlyEnabled onlyOwner {
        cbdd.actionYield(recipient, address(0x0), uint(Actions.Action.CREATE_DATA_SOURCE));
    }
}
