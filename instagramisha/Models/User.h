//
//  User.h
//  instagramisha
//
//  Created by Roesha Nigos on 7/11/18.
//  Copyright © 2018 codepath. All rights reserved.
//

#import "PFUser.h"
#import <Parse/Parse.h>

@interface User : PFUser<PFSubclassing>

@property PFFile *profileImage;
@property NSString *bio; 
- (void) updateDefault:(UIImage *)photo withCompletion:(PFBooleanResultBlock)completion;

@end
