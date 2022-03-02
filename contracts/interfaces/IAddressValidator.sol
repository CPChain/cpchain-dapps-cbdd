pragma solidity ^0.4.24;

interface IAddressValidator {
    /**
     * Validate address
     * @param addr address
     * @return (verified, error)
     */
    function validateAddress(address addr) external returns (bool, string);
}
