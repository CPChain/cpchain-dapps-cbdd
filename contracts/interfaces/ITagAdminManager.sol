pragma solidity ^0.4.24;

interface ITagAdminManager {

    /**
     * @param tags split by ","
     */
    function addTagToWhiteList(string) external;

    /**
     * @param tags split by ","
     */
    function removeTagFromWhiteList(string) external;

    /**
     * @param max_tags
     */
    function setMaxTagsPerDataElement(uint) external;
}
