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
    function setIsAllowedDislikeComment(bool allowed) external;
}
