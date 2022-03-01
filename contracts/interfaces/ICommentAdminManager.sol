pragma solidity ^0.4.24;

interface ICommentAdminManager {

    function setMaxCommentLength(uint) external;

    function setMinCommentLength(uint) external;

    function setIsAllowedDislikeComment(bool) external;

}
