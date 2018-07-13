//
//  CustomCameraViewController.m
//  instagramisha
//
//  Created by Roesha Nigos on 7/11/18.
//  Copyright © 2018 codepath. All rights reserved.
//

#import "CustomCameraViewController.h"
#import "Post.h"
#import <MBProgressHUD/MBProgressHUD.h>


@interface CustomCameraViewController () <AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UIImageView *captureImageView;
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCapturePhotoOutput *stillImageOutput;
@property (nonatomic) Post *post;

@property (nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;



@end

@implementation CustomCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //settig a new session
    self.session = [AVCaptureSession new];
    self.session.sessionPreset = AVCaptureSessionPresetMedium;
    
    //setting up the back camera
    AVCaptureDevice *backCamera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera
                                                                        error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    // adding input to the session 
    else if (self.session && [self.session canAddInput:input]) {
        [self.session addInput:input];
        // The remainder of the session setup will go here...
    }
    self.stillImageOutput = [AVCapturePhotoOutput new];

    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
        
        //Configure the Live Preiview here
        
        self.videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        if (self.videoPreviewLayer) {
            self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            self.videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
            [self.previewView.layer addSublayer:self.videoPreviewLayer];
            [self.session startRunning];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTakePhoto:(id)sender {
    AVCapturePhotoSettings *settings = [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey: AVVideoCodecTypeJPEG}];
    //Capture Photo
    [self.stillImageOutput capturePhotoWithSettings:settings delegate:self];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.videoPreviewLayer.frame = self.previewView.bounds;
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

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(nullable NSError *)error {
    
    NSData *imageData = photo.fileDataRepresentation;
    UIImage *image = [UIImage imageWithData:imageData];
    NSString *kCGI = (NSString *)kCGImagePropertyOrientation;
    UIImage *imageRep = [UIImage imageWithCGImage:photo.CGImageRepresentation scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationRight];
    // Add the image to captureImageView here...
    self.captureImageView.image = imageRep;
    self.post.image = imageRep; 
    
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


- (UIImage *)fixOrientationOfImage:(UIImage *)image {
    
    // No-op if the orientation is already correct
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
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
    self.captureImageView.image = newResizedImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapShare:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if(![self.captureImageView.image isEqual:[UIImage imageNamed:@"image_placeholder"]]){
        [Post postUserImage:[self fixOrientationOfImage:self.captureImageView.image] withCaption:@"" withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                self.captureImageView.image = [UIImage imageNamed:@"placeholder_image"];
                //self.captionTextView.text = @"";
                NSLog(@"posted!!");
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //[self dismissViewControllerAnimated:YES completion:nil];
                
            }
            else {
                NSLog(@"ERROR: @%" , error.localizedDescription);
            }
            
        }];
}
}
    
- (IBAction)didTapCaption:(id)sender {
    //NSString *customText =
    //NSString *customText = self.captionText.text;
    [self.captionText resignFirstResponder];
}

-(void)touchBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.captionText resignFirstResponder];
    
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

