//
//  AssignmentListViewController.m
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/13/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import "AssignmentListViewController.h"
#import "AssignmentListCell.h"
#import <Parse/Parse.h>
#import "DetailsViewController.h"
#import "SceneDelegate.h"

@interface AssignmentListViewController () <UITableViewDelegate, UITableViewDataSource, DetailsViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *assignments;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AssignmentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchAssignments];
    
}

- (void)fetchAssignments {
    PFQuery *assignmentQuery = [PFQuery queryWithClassName:@"Assignment"];
    [assignmentQuery orderByAscending:@"dueDate"];
    [assignmentQuery whereKey:@"creationComplete" equalTo: @YES];
    [assignmentQuery whereKey:@"author" equalTo: [PFUser currentUser]];
//    assignmentQuery.limit = 20;
    
    [assignmentQuery findObjectsInBackgroundWithBlock:^(NSArray<Assignment *>* _Nullable assignments, NSError * _Nullable error) {
        if (assignments) {
            self.assignments = (NSMutableArray *) assignments;
             [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}

- (IBAction)onLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        if (error != nil) {
            NSLog(@"User log out failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged out successfully");
            FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
            [loginManager logOut];
            
            if ([FBSDKAccessToken currentAccessToken] == nil) {
                SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                UIViewController *loginController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                myDelegate.window.rootViewController = loginController;
            } else {
                NSLog(@"error logging out");
            }
        }
    }];
}


 - (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
     AssignmentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssignmentListCell"];
     Assignment *assignment = self.assignments[indexPath.row];
     
     cell.assignment = assignment;
     
     return cell;
 }

 - (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.assignments.count;
 }
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected row number: %ld", (long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailsViewController *detailsViewController = [[DetailsViewController alloc] init];
    detailsViewController.delegate = self;
    
    [detailsViewController updateCellProgress:indexPath];
    [tableView reloadData];
}

//-(void)updateProgressBar:(NSNumber *)percentage {
//    DetailsViewController *detailsViewController= [[DetailsViewController alloc] init];
//    detailsViewController.delegate = self;
//
//    [detailsViewController updateCellProgress];
//
//}

-(void)didUpdateCell:(NSIndexPath *)indexPath withValue:(NSNumber *)percentage {
    NSLog(@"ASSIGNMENT UPDATING IN LIST AT INDEX @%ld", (long)indexPath.row);
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    AssignmentListCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.progressBar setProgress:[percentage floatValue]];
}

// delete cells
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.assignments removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        // delete cell in parse
    } else {
        NSLog(@"Unhandled editing style! %ld", (long)editingStyle);
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if(![sender isKindOfClass:[UIBarButtonItem class]]) {
        AssignmentListCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Assignment *assignment = self.assignments[indexPath.row];
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.assignment = assignment;
//        detailsViewController.indexNumber = indexPath;
//        [detailsViewController updateCellProgress:indexPath];
        NSLog(@"Tapping on an assignment!");
    }
}

/*
 AsssignmentListViewController needs to be a delegate of DetailsViewController
 DetailsVC has a protocol with method to update
 Method willl take in progress value
 Will make cell update
 */

@end
