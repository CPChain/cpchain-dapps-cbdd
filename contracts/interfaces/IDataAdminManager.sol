pragma solidity ^0.4.24;

interface IDataAdminManager {
    /**
     * Allowed user dislike a data element
     * @param allowed allowed
     */
    function setIfAllowedDislike(bool allowed) external;

    /**
     * Set the one-address upper limit of data elements
     * @param upper upper
     */
    function setOneAddressUpperLimitOfDataElements(uint upper) external;

    /**
     * Set the max length of a name
     * @param length length
     */
    function setMaxLengthOfName(uint length) external;

    /**
     * Set the min length of a name
     * @param length length
     */
    function setMinLengthOfName(uint length) external;

    /**
     * Set the max length of the description
     * @param length length
     */
    function setMaxLengthOfDescription(uint length) external;

    /**
     * Set the min length of the description
     * @param length length
     */
    function setMinLengthOfDescription(uint length) external;
}
