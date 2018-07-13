//
//  User.m
//  instagramisha
//
//  Created by Roesha Nigos on 7/11/18.
//  Copyright © 2018 codepath. All rights reserved.
//

#import "User.h"


@implementation User
  @dynamic profileImage;

//if plus cant do self plus is only class
- (PFFile *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    return [PFFile fileWithName:@"image.png" data:imageData];
}

- (void) updateDefault:(UIImage *)photo withCompletion:(PFBooleanResultBlock)completion{
    self.profileImage = [self getPFFileFromImage:photo];
    [self saveInBackground];
}



@end
