//
//  PostCell.h
//  instagramisha
//
//  Created by Roesha Nigos on 7/10/18.
//  Copyright © 2018 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import <ParseUI/ParseUI.h>
#import "PostViewController.h"

@interface PostCell : UITableViewCell <PostViewControllerDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic)  Post *post;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userPicView;
//@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

//going to access this publicly in TimelineViewController
-(void)configureCell: (Post *) post;
@end
