pragma solidity ^0.4.24;

interface IDataAdminManager {

    /**
     * Allowed user dislike a data element
     */
    function setIfAllowedDislike(bool) external;

}
