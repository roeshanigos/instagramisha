//
//  PostCollectionViewCell.h
//  instagramisha
//
//  Created by Roesha Nigos on 7/11/18.
//  Copyright © 2018 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import <ParseUI/ParseUI.h>

@interface PostCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
@property (strong, nonatomic)  Post *post;
-(void)configureCell: (Post *) post;

@end
