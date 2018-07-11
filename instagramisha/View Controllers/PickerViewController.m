//
//  PickerViewController.m
//  instagramisha
//
//  Created by Roesha Nigos on 7/9/18.
//  Copyright © 2018 codepath. All rights reserved.
//

#import "PickerViewController.h"
#import <UIKit/UIKit.h>
#import "Post.h"

//we have to declare a class that implements the require protocols for
@interface PickerViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *instaImageView;
@property (weak, nonatomic) IBOutlet UITextView *captionTextView;

@end

@implementation PickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)didTapImage:(id)sender {
    //instantiating a UI Picker Controller
    [self getImage];
}

- (IBAction)didTapAway:(id)sender {
    [self.view endEditing:YES];
}

-(void)getImage{
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    //setting the delegates and the data source
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    //ASK
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
     [self presentViewController:imagePickerVC animated:YES completion:nil];
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

// i am implementing the delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    //ASK
    // Getting image captured by the PickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    //WHY CALL TO SELF ASK
    UIImage *newResizedImage = [self resizeImage:editedImage withSize:CGSizeMake(400.0, 400.0)];
    self.instaImageView.image = newResizedImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];

}

- (IBAction)didTapShare:(id)sender {
    if(![self.instaImageView.image isEqual:[UIImage imageNamed:@"image_placeholder"]]){
        [Post postUserImage:self.instaImageView.image withCaption:self.captionTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                self.instaImageView.image = [UIImage imageNamed:@"placeholder_image"];
                self.captionTextView.text = @"";
                NSLog(@"posted!!");
            }
            else {
                NSLog(@"ERROR: @%" , error.localizedDescription);
            }
        }];
    }
    [self dismissViewControllerAnimated:true completion:nil];

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
