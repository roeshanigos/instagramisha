//
//  PostCell.m
//  instagramisha
//
//  Created by Roesha Nigos on 7/10/18.
//  Copyright © 2018 codepath. All rights reserved.
//

#import "PostCell.h"
#import "Post.h"
#import <ParseUI/ParseUI.h>
#import <DateTools/NSDate+DateTools.h>
#import <Parse/Parse.h>
#import "User.h"



@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)configureCell: (Post *) post {
    self.post = post;
    User *user = [User currentUser];
    PFFile *profile_image = user.profileImage;
    self.userImageView.file = profile_image;
    self.userLabel.text = user.username;
    //PFFiles is a pointer with URL
    [self.userImageView loadInBackground];
    self.postImageView.file = post[@"image"];
    [self.postImageView loadInBackground];
    self.captionLabel.text = post[@"caption"];
    self.likeButton.selected = [post likedByCurrentUser];
    self.createdAtLabel.text = [post.createdAt timeAgoSinceNow];
    NSString *likes = [NSString stringWithFormat:@"%@", post[@"likeCount"]];
    self.likeLabel.text = likes;
    self.userImageView.layer.cornerRadius= self.userImageView.frame.size.height/2;
    //self.likeButton.selected = [post likedByCurrentUser];
    
    if(self.post.didLiked){
        self.likeButton.selected = YES;
    }
    else {
        self.likeButton.selected = NO;
    }
    
}

-(void)toggleLike{
    if(self.post.didLiked) {
        self.likeButton.selected = NO;
        self.post.didLiked = NO;
        self.post.likeCount = @([self.post.likeCount intValue]-1);
        self.likeLabel.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
        [self.post saveInBackground];
        
    }
    else {
        self.likeButton.selected = YES;
        self.post.didLiked = YES;
        self.post.likeCount = @([self.post.likeCount intValue] + 1);
        self.likeLabel.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
        [self.post saveInBackground];

    }
//NEW SOLUTION DONT NEED THIS
//    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
//    [query includeKey:@"author"];
//
//    [query getObjectInBackgroundWithId:self.post.objectId block:^(PFObject * _Nullable object, NSError * _Nullable error) {
//        if (object){
//            Post *post = (Post *)object;
//            if ([post likedByCurrentUser]) {
//                [post incrementKey:@"likeCount" byAmount:@(-1)];
//                [post removeObject:PFUser.currentUser.objectId forKey:@"likedBy"];
//            }
//            else {
//                [post incrementKey:@"likeCount" byAmount:(@1)];
//                [post removeObject:PFUser.currentUser.objectId forKey:@"likedBy"];
//            }
//            [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//                if (succeeded){
//                    self.post = post;
//                    [self refresh];
//                }
//            }];
//        }
//
//        else {
//            NSLog(@"Error: %@", error.localizedDescription);
//        }
//        }];
}

- (void) refresh {
    self.likeButton.selected = [self.post likedByCurrentUser];
    
}

- (IBAction)didTapLike:(id)sender {
    [self toggleLike];
}

-(void)didUpdatePost:(Post *) post{
    self.post = post;
    [self refresh];
}

@end
