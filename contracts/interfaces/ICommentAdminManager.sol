pragma solidity ^0.4.24;

interface ICommentAdminManager {

    /**
     * Set the max comment length
     * @param length length
     */
    function setMaxCommentLength(uint length) external;

    /**
     * Set the min comment length
     * @param length length
     */
    function setMinCommentLength(uint length) external;

    /**
     * Set if allowed dislike a comment
     * @param allowed allowed
     */
    function setIfAllowedDislikeComment(bool allowed) external;

    // get configs
    function getCommentContext() external view returns (uint minLen, uint maxLen, bool allowedDislike);
}
