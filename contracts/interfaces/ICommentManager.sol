pragma solidity ^0.4.24;

interface ICommentManager {

    event AddCommentOfDataSource(uint source_id, uint comment_id, address sender, string comment);

    event AddCommentOfDataChart(uint chart_id, uint comment_id, address sender, string comment);

    event AddCommentOfDataDashboard(uint dashboard_id, uint comment_id, address sender, string comment);

    event UpdateComment(uint comment_id, string comment);

    event ReplyComment(uint comment_id, uint reply_comment_id, address sender, string comment);

    event DeleteComment(uint comment_id);

    event LikeComment(uint comment_id, address sender);

    event CancelLikeComment(uint comment_id, address sender);

    event DislikeComment(uint comment_id, address sender);

    event CanceldislikeComment(uint comment_id, address sender);

    function addCommentOfDataSource(uint, string) external returns (uint);

    function addCommentOfDataChart(uint, string) external returns (uint);

    function addCommentOfDataDashboard(uint, string) external returns (uint);

    function updateComment(uint, string) external;

    function deleteComment(uint) external;

    function replyComment(uint, string) external;

    function likeComment(uint) external;

    function cancelLikeComment(uint) external;

    function cancelDislikeComment(uint) external;

}
