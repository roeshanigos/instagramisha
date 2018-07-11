//
//  TimelineViewController.m
//  instagramisha
//
//  Created by Roesha Nigos on 7/9/18.
//  Copyright © 2018 codepath. All rights reserved.
//

#import "TimelineViewController.h"
#import "UIImageView+AFNetworking.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Post.h"
#import "PostCell.h"
#import <ParseUI/ParseUI.h>
#import "PostViewController.h"
#import "PickerViewController.h"




@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *refreshIndicator;
@property (assign, nonatomic) BOOL isMoreDataLoading;



@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //self.posts =  [NSArray array];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self. refreshControl];
    [self.tableView addSubview:self.refreshControl];
    
    [self fetchPosts];
}


-(void)fetchPosts{
    [self.refreshIndicator startAnimating]; 

    //PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    PFQuery *query = [Post query];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
//  [query whereKey:@"likesCount" greaterThan:@100];
    //query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            [self.tableView reloadData];

        } else {
            NSLog(@"%@", error.localizedDescription);
            //[self.tableView reloadData];

        }
        [self.refreshIndicator stopAnimating];
    }];
    [self.refreshControl endRefreshing];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didTapPicture:(id)sender {
    [self performSegueWithIdentifier:@"picSegue" sender:nil];

}

- (IBAction)didTapLogout:(id)sender {
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        
       // [self performSegueWithIdentifier:@"backSegue" sender:nil]; DONT DO THIS!
        
        //creating a new app delegate (configuration file) has a delegate property (an object) ACCESS THAT APP DEL OBJECT
        // instantiating a VC and want it to show completely and tell app delegate do this
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        appDelegate.window.rootViewController = loginViewController;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.posts.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //recycling and showing cells
    PostCell *postCell = [self.tableView dequeueReusableCellWithIdentifier:@"postCell"];
    Post *post = self.posts[indexPath.row];
    [postCell configureCell:post];

    return postCell;    
    
}

-(void)getMoreData{
        if (self.posts){
            [self.tableView reloadData];
            NSLog(@"yay");
        }
        else {
            NSLog(@"oopsies");
        }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            
            // Code to load more results
            [self getMoreData];
            
        }
    }
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    if ([segue.identifier isEqual:@"picSegue" ]) {
//        PickerViewController *pickerController = [segue destinationViewController];
//
//    }
    if ([segue.identifier isEqual:@"detailPost" ]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.posts[indexPath.row];
        PostViewController *postViewController = [segue destinationViewController];
        postViewController.post = post;
    }
}





@end
