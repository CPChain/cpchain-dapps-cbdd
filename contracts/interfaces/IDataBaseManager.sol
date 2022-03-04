pragma solidity ^0.4.24;

interface IDataBaseManager {
    /**
     * @param sender sender
     * @param id source ID
     */
    event LikeEvent(address sender, uint id);

    /**
     * @param sender sender
     * @param id source ID
     */
    event CancelLikeEvent(address sender, uint id);

    /**
     * @param sender sender
     * @param id source ID
     */
    event DislikeEvent(address sender, uint id);

    /**
     * @param sender sender
     * @param id source ID
     */
    event CancelDislikeEvent(address sender, uint id);

    /**
     * @param id source ID
     */
    event EnableDataElementEvent(uint id);

    /**
     * @param id source ID
     */
    event DisableDataElementEvent(uint id);

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

    // views
    function existsID(uint id) external view returns (bool);

    function existsName(string name) external view returns (bool);

    function isLiked(uint id, address sender) external view returns (bool);

    function isDisliked(uint id, address sender) external view returns (bool);

    function getDataElementOwner(uint id) external view returns (address);

    function getDataElement(uint id) external view returns (uint source_id, address sender, string name, string desc);

    /**
     * Enable a data source
     * Emits {EnableDataElementEvent}
     * @param id ID
     */
    function enableDataElement(uint id) external;

    /**
     * Disable a data source
     * Emits {DisableDataElementEvent}
     * @param id ID
     */
    function disableDataElement(uint id) external;

    function isDisabled(uint id) external view returns (bool);
}
