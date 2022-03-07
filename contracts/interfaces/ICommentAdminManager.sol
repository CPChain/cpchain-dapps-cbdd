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

    // views
    function getComment(uint id) external view returns (uint commentID, address sender, string comment, uint replyTo);

    function getCommentOwner(uint id) external view returns (address sender);

    function isLikedComment(uint id, address sender) external view returns (bool);

    function isDislikedComment(uint id, address sender) external view returns (bool);
}
