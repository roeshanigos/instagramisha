//
//  PostViewController.m
//  instagramisha
//
//  Created by Roesha Nigos on 7/10/18.
//  Copyright © 2018 codepath. All rights reserved.
//

#import "PostViewController.h"
#import "Post.h"
#import "PostCell.h"
#import <ParseUI/ParseUI.h>

@interface PostViewController ()
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end

@implementation PostViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureCell:self.post];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureCell: (Post *) post {
    self.postImageView.file = post[@"image"];
    [self.postImageView loadInBackground];
    self.captionLabel.text = post[@"caption"];
    NSString *likes = [NSString stringWithFormat:@"%@", post[@"likeCount"]];
    self.likeLabel.text = likes;
    self.likeButton.selected = [post likedByCurrentUser];
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
//    }];
}

- (void) refresh {
    self.likeButton.selected = [self.post likedByCurrentUser];
    
}

- (IBAction)didTapLike:(id)sender {
    [self toggleLike];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
