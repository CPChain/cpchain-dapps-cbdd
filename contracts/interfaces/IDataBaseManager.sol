pragma solidity ^0.4.24;

interface IDataBaseManager {
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

    function getIfAllowedDislike() external view returns (bool);

    function getUpperElementsPerAddress() external view returns (uint);

    function getLengthOfName() external view returns (uint min, uint max);

    function getLengthOfDesc() external view returns (uint min, uint max);
}
