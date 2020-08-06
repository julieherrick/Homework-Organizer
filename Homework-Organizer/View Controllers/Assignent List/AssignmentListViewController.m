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

// theme items
#import <MaterialComponents/MaterialButtons+ColorThemer.h>
#import <MaterialComponents/MaterialButtons+TypographyThemer.h>

#import <MaterialComponents/MaterialTextFields+ColorThemer.h>
#import <MaterialComponents/MaterialTextFields.h>

#import "MaterialTextFields+Theming.h"
#import "MaterialContainerScheme.h"
#import "MaterialTypographyScheme.h"
#import <MaterialComponents/MaterialButtons.h>
#import <MaterialComponents/MaterialButtons+Theming.h>

#import "ApplicationScheme.h"

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
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:nil];
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
     cell.layer.cornerRadius = 10;
     cell.layer.masksToBounds = true;
     
     return cell;
 }

 - (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.assignments.count;
 }
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected row number: %ld", (long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [tableView reloadData];
}

-(void)didUpdateAssignmentCell:(NSIndexPath *)indexPath withValue:(NSNumber *)percentage {
    NSLog(@"ASSIGNMENT UPDATING IN LIST AT INDEX @%ld", (long)indexPath.row);
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    AssignmentListCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.progressBar setProgress:[percentage floatValue]];
}

// delete cells
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSLog(@"Row @%ld", (long)indexPath.row);
        // delete cell in parse
        Assignment *current = [self.assignments objectAtIndex:indexPath.row];
        NSLog(@"Deleting @%@", current.title);
        [self deleteAssignment:current];
        [self.assignments removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        NSLog(@"Unhandled editing style! %ld", (long)editingStyle);
    }
}
-(void)deleteAssignment:(Assignment *)assignment {
    PFQuery *assignmentQuery = [PFQuery queryWithClassName:@"Assignment"];
    [assignmentQuery whereKey:@"objectId" equalTo: assignment.objectId];
    NSLog(@"Assignment ID @%@", assignment.objectId);
    [assignmentQuery findObjectsInBackgroundWithBlock:^(NSArray<Assignment *>* _Nullable assignments, NSError * _Nullable error) {
        if (!error) {
            for (Assignment *asgnmt in assignments) {
                [self deleteParentSubtasks:asgnmt];
                [asgnmt deleteInBackground];
                NSLog(@"Deleting assignment...");
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}
-(void)deleteParentSubtasks:(Assignment *)assignment {
    PFRelation *relation = [assignment relationForKey:@"Subtask"];
    PFQuery *query = [relation query];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray<Subtask *>* _Nullable subtasks, NSError * _Nullable error) {
        if (!error) {
            for (Subtask *task in subtasks) {
                if (task.isParentTask) {
                    [self deleteChildSubtasks:task];
                }
                [task deleteInBackground];
                NSLog(@"Deleting parent task...");
            }
        }
    }];
}

-(void)deleteChildSubtasks:(Subtask *)parent {
    PFRelation *relation = [parent relationForKey:@"Subtask"];
    PFQuery *query = [relation query];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray<Subtask *>* _Nullable subtasks, NSError * _Nullable error) {
        if (!error) {
            for (Subtask *task in subtasks) {
                if (task.isParentTask) {
                    [self deleteChildSubtasks:task];
                }
                [task deleteInBackground];
                NSLog(@"Deleting child task...");
            }
        }
    }];
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
        detailsViewController.indexNumber = indexPath;
        detailsViewController.delegate = self;
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
