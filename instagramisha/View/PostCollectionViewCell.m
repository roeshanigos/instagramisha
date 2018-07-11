//
//  PostCollectionViewCell.m
//  instagramisha
//
//  Created by Roesha Nigos on 7/11/18.
//  Copyright © 2018 codepath. All rights reserved.
//

#import "PostCollectionViewCell.h"
#import "Post.h"
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>

@implementation PostCollectionViewCell

-(void)configureCell: (Post *) post {
    self.post = post;
    self.postImageView.file = post[@"image"];
    [self.postImageView loadInBackground];
    
}


@end
