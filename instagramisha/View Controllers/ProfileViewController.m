//
//  ProfileViewController.m
//  instagramisha
//
//  Created by Roesha Nigos on 7/10/18.
//  Copyright © 2018 codepath. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "PostCollectionViewCell.h"
#import "PostViewController.h"
#import "Post.h"
#import "User.h"
#import "UpdateImageViewController.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *refreshIndicator;
@property (nonatomic,strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UILabel *postsCount;
@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (strong, nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self fetchPosts];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    CGFloat postsPerLine = 3;
    CGFloat itemWidth = self.collectionView.frame.size.width/ postsPerLine;
    CGFloat itemHeight = itemWidth ;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self. refreshControl];
    [self.collectionView addSubview:self.refreshControl];
    self.userImageView.layer.cornerRadius= self.userImageView.frame.size.height/2;
    User *user = [User currentUser];
    PFFile *profile_image = user.profileImage;
    self.userImageView.file = profile_image;
    self.userLabel.text = user.username;
    //PFFiles is a pointer with URL
    [self.userImageView loadInBackground];
    [self.collectionView reloadData];
    
   
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.posts.count; 
    
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PostCollectionViewCell *postCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"postIdentifier" forIndexPath:indexPath];
    Post *post = self.posts[indexPath.row];
    [postCell configureCell:post];
    //postCell.post = post;
    //[postCell.imageView setImageWithURL:[NSURL URLWithString:post.image.url]];
    return postCell;
    
}


-(void)fetchPosts{
    [self.refreshIndicator startAnimating];
    
    //PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    PFQuery *query = [Post query];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    //  [query whereKey:@"likesCount" greaterThan:@100];
    //query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            [self.collectionView reloadData];
            self.postsCount.text = [NSString stringWithFormat:@"%lu",self.posts.count];

            
        } else {
            NSLog(@"%@", error.localizedDescription);
            //[self.tableView reloadData];
            
        }
        [self.refreshIndicator stopAnimating];
    }];
    [self.refreshControl endRefreshing];
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqual:@"detailPostColl" ]){
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        Post *post = self.posts[indexPath.row];
        PostViewController *postViewController = [segue destinationViewController];
        postViewController.post = post;
    }
}

@end
