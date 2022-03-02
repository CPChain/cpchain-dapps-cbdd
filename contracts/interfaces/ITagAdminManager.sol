pragma solidity ^0.4.24;

interface ITagAdminManager {

    /**
     * @param tags split by ","
     */
    function addTagToWhiteList(string tags) external;

    /**
     * @param tags split by ","
     */
    function removeTagFromWhiteList(string tags) external;

    /**
     * @param max_tags max tags
     */
    function setMaxTagsPerDataElement(uint max_tags) external;
}
