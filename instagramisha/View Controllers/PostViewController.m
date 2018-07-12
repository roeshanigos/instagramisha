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


}

- (IBAction)didTapLike:(id)sender {
    if (self.likeButton.selected){
        self.likeButton.selected = false;
        NSNumber *likeNumber = [NSNumber numberWithInteger:[self.post.likeCount intValue]-1];
        self.likeLabel.text = [NSString stringWithFormat:@"%@", likeNumber];
        self.post.likeCount = [NSNumber numberWithInteger:[self.post.likeCount intValue]-1];
        [self.post saveInBackground];
    }
    else {
        self.likeButton.selected = true;
        NSNumber *likeNumber = [NSNumber numberWithInteger:[self.post.likeCount intValue]+1];
        self.likeLabel.text = [NSString stringWithFormat:@"%@", likeNumber];
        self.post.likeCount = [NSNumber numberWithInteger:[self.post.likeCount intValue]+1];
        [self.post saveInBackground];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
