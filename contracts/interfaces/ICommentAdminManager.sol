pragma solidity ^0.4.24;

interface ICommentAdminManager {

    /**
     * Set the max comment length
     * @param length
     */
    function setMaxCommentLength(uint) external;

    /**
     * Set the min comment length
     */
    function setMinCommentLength(uint) external;

    /**
     * Set if allowed dislike a comment
     */
    function setIsAllowedDislikeComment(bool) external;
}
