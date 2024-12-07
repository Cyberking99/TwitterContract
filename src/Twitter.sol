// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Twitter {
    address public owner;
    uint private tweetCounter;
    uint private replyCounter;
    uint private reportCounter;

    constructor() {
        owner = msg.sender;
    }

    struct Tweet {
        uint id;
        address tweetSender;
        string tweetText;
        string tweetImage;
        uint timestamp;
        uint likeCount;
        uint tipAmount;
    }

    struct Reply {
        uint id;
        uint tweetId;
        address replySender;
        string replyText;
        uint timestamp;
    }

    struct Report {
        uint id;
        uint tweetId;
        address reporter;
        string reason;
        uint timestamp;
    }

    struct UserProfile {
        string username;
        string bio;
        string profilePicture;
    }

    mapping(uint => Tweet) private tweets;
    mapping(uint => Reply[]) private replies;
    mapping(uint => address[]) private likes;
    mapping(uint => Report[]) private reports;
    mapping(address => UserProfile) public profiles;
    mapping(address => address[]) public followers;
    mapping(address => address[]) public following;

    event TweetCreated(uint id, address indexed tweetSender, string tweetText, string tweetImage, uint timestamp);
    event ReplyCreated(uint id, uint tweetId, address indexed replySender, string replyText, uint timestamp);
    event TweetLiked(uint tweetId, address indexed liker);
    event TipSent(uint tweetId, address indexed sender, uint amount);
    event ProfileUpdated(address indexed user, string username, string bio, string profilePicture);
    event Follow(address indexed follower, address indexed following);
    event Unfollow(address indexed follower, address indexed following);
    event TweetReported(uint reportId, uint tweetId, address indexed reporter, string reason);
    
    function sendTweet(string memory _tweetText, string memory _tweetImage) external {
        tweets[tweetCounter] = Tweet(tweetCounter, msg.sender, _tweetText, _tweetImage, block.timestamp, 0, 0);
        emit TweetCreated(tweetCounter, msg.sender, _tweetText, _tweetImage, block.timestamp);
        tweetCounter++;
    }

    function replyToTweet(uint _tweetId, string memory _replyText) external {
        require(_tweetId < tweetCounter, "Tweet does not exist");
        replies[_tweetId].push(Reply(replyCounter, _tweetId, msg.sender, _replyText, block.timestamp));
        emit ReplyCreated(replyCounter, _tweetId, msg.sender, _replyText, block.timestamp);
        replyCounter++;
    }

    function likeTweet(uint _tweetId) external {
        require(_tweetId < tweetCounter, "Tweet does not exist");
        for (uint i = 0; i < likes[_tweetId].length; i++) {
            require(likes[_tweetId][i] != msg.sender, "Already liked");
        }
        likes[_tweetId].push(msg.sender);
        tweets[_tweetId].likeCount++;
        emit TweetLiked(_tweetId, msg.sender);
    }

    function sendTip(uint _tweetId) external payable {
        require(_tweetId < tweetCounter, "Tweet does not exist");
        tweets[_tweetId].tipAmount += msg.value;
        emit TipSent(_tweetId, msg.sender, msg.value);
    }

    function updateProfile(string memory _username, string memory _bio, string memory _profilePicture) external {
        profiles[msg.sender] = UserProfile(_username, _bio, _profilePicture);
        emit ProfileUpdated(msg.sender, _username, _bio, _profilePicture);
    }

    function followUser(address _user) external {
        require(_user != msg.sender, "Cannot follow yourself");
        followers[_user].push(msg.sender);
        following[msg.sender].push(_user);
        emit Follow(msg.sender, _user);
    }

    function unfollowUser(address _user) external {
        require(_user != msg.sender, "Cannot unfollow yourself");
        removeFollower(_user, msg.sender);
        removeFollowing(msg.sender, _user);
        emit Unfollow(msg.sender, _user);
    }

    function reportTweet(uint _tweetId, string memory _reason) external {
        require(_tweetId < tweetCounter, "Tweet does not exist");
        reports[_tweetId].push(Report(reportCounter, _tweetId, msg.sender, _reason, block.timestamp));
        emit TweetReported(reportCounter, _tweetId, msg.sender, _reason);
        reportCounter++;
    }

    function getTweet(uint _id) external view returns (Tweet memory) {
        require(_id < tweetCounter, "Tweet does not exist");
        return tweets[_id];
    }

    function getReplies(uint _tweetId) external view returns (Reply[] memory) {
        require(_tweetId < tweetCounter, "Tweet does not exist");
        return replies[_tweetId];
    }

    function getFollowing(address user) external view returns (address[] memory) {
        return following[user];
    }

    function getReports(uint _tweetId) external view returns (Report[] memory) {
        require(_tweetId < tweetCounter, "Tweet does not exist");
        return reports[_tweetId];
    }

    function removeFollower(address _user, address _follower) private {
        address[] storage userFollowers = followers[_user];
        for (uint i = 0; i < userFollowers.length; i++) {
            if (userFollowers[i] == _follower) {
                userFollowers[i] = userFollowers[userFollowers.length - 1];
                userFollowers.pop();
                break;
            }
        }
    }

    function removeFollowing(address _user, address _following) private {
        address[] storage userFollowing = following[_user];
        for (uint i = 0; i < userFollowing.length; i++) {
            if (userFollowing[i] == _following) {
                userFollowing[i] = userFollowing[userFollowing.length - 1];
                userFollowing.pop();
                break;
            }
        }
    }
}
