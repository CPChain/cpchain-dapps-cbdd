pragma solidity ^0.4.24;

import "@cpchain-tools/cpchain-dapps-utils/contracts/lifecycle/Enable.sol";

import "../interfaces/IDataAdminManager.sol";
import "../interfaces/IVersion.sol";
import "./ControllerIniter.sol";


contract DataBaseManager is Enable, IVersion, ControllerIniter, IDataAdminManager {
    // context
    struct Context {
        uint version;
        bool allowedDislike;
        uint maxLenOfName;
        uint minLenOfName;
        uint maxLenOfDescription;
        uint minLenOfDescription;
        uint addressDataElementsUpper;
    }
    Context internal context;

    // address count
    mapping(address => uint) internal addrElementsCnt;

    constructor() public {
        context.version = 0;
        context.allowedDislike = true;
        context.maxLenOfDescription = 200;
        context.minLenOfDescription = 1;
        context.maxLenOfName = 50;
        context.minLenOfName = 1;
        context.addressDataElementsUpper = 500;
    }

    function version() public view returns (uint) {
        return context.version;
    }

    modifier validateNameLength(string name) {
        uint length = bytes(name).length;
        require(length <= context.maxLenOfDescription && length >= context.minLenOfName,
            "Length of name is not in the range");
        _;
    }
    modifier validateDescLength(string desc) {
        uint length = bytes(desc).length;
        require(length <= context.maxLenOfDescription && length >= context.minLenOfDescription,
            "Length of desc is not in the range");
        _;
    }
    modifier elementsCntLessThanUpper(address sender) {
        require(addrElementsCnt[sender] < context.addressDataElementsUpper, "You have created too many elements");
        _;
    }

    function setIfAllowedDislike(bool allowed) external onlyEnabled onlyOwner {
        context.allowedDislike = allowed;
    }

    function setOneAddressUpperLimitOfDataElements(uint upper) external onlyEnabled onlyOwner {
        context.addressDataElementsUpper = upper;
    }

    function setMaxLengthOfName(uint length) external onlyEnabled onlyOwner {
        context.maxLenOfName = length;
    }

    function setMinLengthOfName(uint length) external onlyEnabled onlyOwner {
        context.minLenOfName = length;
    }

    function setMaxLengthOfDescription(uint length) external onlyEnabled onlyOwner {
        context.maxLenOfDescription = length;
    }

    function setMinLengthOfDescription(uint length) external {
        context.minLenOfDescription = length;
    }
}
