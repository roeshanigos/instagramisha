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
    self.postImageView.file = post[@"image"];
    [self.postImageView loadInBackground];
    self.captionLabel.text = post[@"caption"];
    self.likeButton.selected = [post likedByCurrentUser];
    self.createdAtLabel.text = [post.createdAt shortTimeAgoSinceNow];
    NSString *likes = [NSString stringWithFormat:@"%@", post[@"likeCount"]];
    self.likeLabel.text = likes;
    self.userPicView.layer.cornerRadius= self.userPicView.frame.size.height/2;
    self.likeButton.selected = [post likedByCurrentUser];
    
}

-(void)toggleLike{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    
    [query getObjectInBackgroundWithId:self.post.objectId block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object){
            Post *post = (Post *)object;
            if ([post likedByCurrentUser]) {
                [post incrementKey:@"likeCount" byAmount:@(-1)];
                [post removeObject:PFUser.currentUser.objectId forKey:@"likedBy"];
            }
            else {
                [post incrementKey:@"likeCount" byAmount:(@1)];
                [post removeObject:PFUser.currentUser.objectId forKey:@"likedBy"];
            }
            [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded){
                    self.post = post;
                    [self refresh];
                }
            }];
        }
        
        else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        }];
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
