//
//  UpdateImageViewController.m
//  instagramisha
//
//  Created by Roesha Nigos on 7/12/18.
//  Copyright © 2018 codepath. All rights reserved.
//

#import "UpdateImageViewController.h"
#import <ParseUI.h>
#import <PFUser.h>
#import "Post.h"
#import "User.h"


@interface UpdateImageViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *proImageView;

@end

@implementation UpdateImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (IBAction)didTapImage:(id)sender {
    //instantiating a UI Picker Controller
    [self getImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getImage {
    //set up image picker, and read from photolibrary
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    //present
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//delegagte method
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
    UIImage *newResizedImage = [self resizeImage:originalImage withSize:CGSizeMake(400, 400)];
    
    //set image
    self.proImageView.image = newResizedImage;
    
    //dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didUploadTapButton:(id)sender {
    User *user = [User currentUser];
    UIImage *image = self.proImageView.image;
    if (image) {
        user.profileImage = [Post getPFFileFromImage:image];
        [user saveInBackground];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
