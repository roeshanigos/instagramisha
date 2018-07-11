//
//  LoginViewController.m
//  instagramisha
//
//  Created by Roesha Nigos on 7/9/18.
//  Copyright © 2018 codepath. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse.h"
#import "User.h"


@interface LoginViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
- (IBAction)didTapRegister:(id)sender {
    [self registerUser];
}
- (IBAction)didTapLogin:(id)sender {
    [self loginUser];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) registerUser {
    //checking if empty
    if ([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]) {
        // we crete a new alert
        NSLog(@"there is an empty field here");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Empty Field" message:@"Please make sure both username and password fields are completed" preferredStyle:UIAlertControllerStyleAlert];
        
        // create an action(button)N for that alert
        //handler is what happens after press action
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {            [self dismissViewControllerAnimated:YES completion:^{
            // more extra stuff just want to dismiss
        }];
        }];
        
        //how to actually apply it
        [alert addAction:okAction];
        
        //want to present after programming error
        [self presentViewController:alert animated:YES completion:^{
            // for when the controler is finished
        }];
    }
    else {
        // initalizes a new user object ..  making a new user
        User *newUser = [User user];
        
        // set user properties
        newUser.username = self.usernameField.text;
        newUser.password = self.passwordField.text;
        
        // call sign up function
        [newUser signUpInBackgroundWithBlock:^(BOOL suceeded, NSError *error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
            }
            else {
                NSLog(@"User registered sucessfully");
                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
                
            }
        }];
    }
}

- (void) loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        //checking if there is an error
        if (error != nil) {
            // localized error description is being sent back to us
            //handles everything for us
            NSLog(@"User log in failed: %@", error.localizedDescription);
            
            // creating a new alert
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"There was an error logging in: %@", error.localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            
            // create an action(button)N for that alert
            //handler is what happens after press action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {            [self dismissViewControllerAnimated:YES completion:^{
                // more extra stuff just want to dismiss
            }];
            }];
            
            //how to actually apply it
            [alert addAction:okAction];
            
            //want to present after programming error
            [self presentViewController:alert animated:YES completion:^{
                // for when the controler is finished
            }];
        }
        else {
            NSLog(@"User logged in sucessfully");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}
- (IBAction)didTapAway:(id)sender {
     [self.view endEditing:YES];
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
