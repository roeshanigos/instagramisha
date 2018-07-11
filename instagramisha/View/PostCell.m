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
    self.postImageView.file = post[@"image"];
    [self.postImageView loadInBackground];
    self.captionLabel.text = post[@"caption"];
    self.createdAtLabel.text = [post.createdAt shortTimeAgoSinceNow];
    NSString *likes = [NSString stringWithFormat:@"%@", post[@"likeCount"]];
    self.likeLabel.text = likes;

    
  

    
}


@end
