//
//  PostViewController.h
//  instagramisha
//
//  Created by Roesha Nigos on 7/10/18.
//  Copyright © 2018 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import "Post.h"

@protocol PostViewControllerDelegate

-(void) didUpdate:(Post *)post;

@end

@interface PostViewController : UIViewController
@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic)  Post *post;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (strong, nonatomic) id<PostViewControllerDelegate> delegate;


@end
