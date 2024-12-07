// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Twitter.sol";

contract TwitterTest is Test {
    Twitter twitter;
    address user1 = address(0x1);
    address user2 = address(0x2);
    uint constant INITIAL_BALANCE = 10 ether;

    function setUp() public {
        twitter = new Twitter();
        
        vm.deal(user1, INITIAL_BALANCE);
        vm.deal(user2, INITIAL_BALANCE);
    }

    function testSendTweet() public {
        vm.prank(user1);
        twitter.sendTweet("Hello, Twitter!", "image1.png");

        Twitter.Tweet memory tweet = twitter.getTweet(0);

        assertEq(tweet.id, 0);
        assertEq(tweet.tweetSender, user1);
        assertEq(tweet.tweetText, "Hello, Twitter!");
        assertEq(tweet.tweetImage, "image1.png");
    }

    function testReplyToTweet() public {
        vm.prank(user1);
        twitter.sendTweet("First tweet", "");

        vm.prank(user2);
        twitter.replyToTweet(0, "Nice tweet!");
        
        Twitter.Reply[] memory replies = twitter.getReplies(0);
        assertEq(replies.length, 1);
        assertEq(replies[0].replyText, "Nice tweet!");
        assertEq(replies[0].replySender, user2);
    }

    function testLikeTweet() public {
        vm.prank(user1);
        twitter.sendTweet("Like this tweet", "");

        vm.prank(user2);
        twitter.likeTweet(0);
        
        Twitter.Tweet memory tweet = twitter.getTweet(0);
        assertEq(tweet.likeCount, 1);
    }

    function testSendTip() public {
        vm.prank(user1);
        twitter.sendTweet("Tip me!", "");

        vm.deal(user2, 1 ether);
        vm.prank(user2);
        twitter.sendTip{value: 1 ether}(0);
        
        Twitter.Tweet memory tweet = twitter.getTweet(0);
        assertEq(tweet.tipAmount, 1 ether);
    }

    function testUpdateProfile() public {
        vm.prank(user1);
        twitter.updateProfile("User1", "I love blockchain", "profile1.png");
        
        (string memory username, string memory bio, string memory profilePicture) = twitter.profiles(user1);
        assertEq(username, "User1");
        assertEq(bio, "I love blockchain");
        assertEq(profilePicture, "profile1.png");
    }

    function testFollowAndUnfollow() public {
        vm.prank(user1);
        twitter.followUser(user2);
        
        address[] memory user1Following = twitter.getFollowing(user1);
        assertEq(user1Following.length, 1);
        assertEq(user1Following[0], user2);

        vm.prank(user1);
        twitter.unfollowUser(user2);
        
        user1Following = twitter.getFollowing(user1);
        assertEq(user1Following.length, 0);
    }

    function testReportTweet() public {
        vm.prank(user1);
        twitter.sendTweet("Report this tweet", "");

        vm.prank(user2);
        twitter.reportTweet(0, "Offensive content");
        
        Twitter.Report[] memory tweetReports = twitter.getReports(0);
        assertEq(tweetReports.length, 1);
        assertEq(tweetReports[0].reason, "Offensive content");
        assertEq(tweetReports[0].reporter, user2);
    }
}
