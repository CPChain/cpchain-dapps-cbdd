pragma solidity ^0.4.24;

interface IAddressValidator {
    /**
     * Validate address
     * @param addr
     */
    function validateAddress(address) external returns (bool, string);
}
