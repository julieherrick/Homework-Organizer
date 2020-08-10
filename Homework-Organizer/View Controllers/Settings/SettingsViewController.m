//
//  SettingsViewController.m
//  Homework-Organizer
//
//  Created by Julie Herrick on 8/7/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import "SettingsViewController.h"
#import "SceneDelegate.h"
#import "Assignment.h"
#import "AssignmentListCell.h"

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) FBSDKLoginButton *loginButton;
@property (strong, nonatomic) NSMutableArray *assignments;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.loginButton = [[FBSDKLoginButton alloc] init];
        self.loginButton.delegate = self;

        self.loginButton.permissions = @[@"public_profile", @"email"];

        self.loginButton.center = self.view.center;
    //    loginButton.size
    [self.loginButton setFrame:CGRectMake(self.view.center.x, 130, 250, 28)];
    self.loginButton.center = CGPointMake(self.view.center.x, 130);
    [self.view addSubview:self.loginButton];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.layer.cornerRadius = 12.0;
    self.topView.layer.cornerRadius = 12.0;
    [self.topView setClipsToBounds:YES];
    
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [self.tableView addGestureRecognizer:doubleTap];
    
    [self fetchAssignments];
}

-(void)doubleTap:(UITapGestureRecognizer *)tap {
    if (UIGestureRecognizerStateEnded == tap.state) {
        CGPoint p = [tap locationInView:tap.view];
        NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:p];

        Assignment *current = [self.assignments objectAtIndex:indexPath.row];
        current.completed = NO;
        [current saveInBackground];
    }
}

- (void)fetchAssignments {
    PFQuery *assignmentQuery = [PFQuery queryWithClassName:@"Assignment"];
    [assignmentQuery orderByDescending:@"dueDate"];
    [assignmentQuery whereKey:@"completed" equalTo: @YES];
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

-(void)onLogout {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        if (error != nil) {
            NSLog(@"User log out failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged out successfully");
            self.loginButton.hidden = YES;
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


- (void)loginButton:(nonnull FBSDKLoginButton *)loginButton didCompleteWithResult:(nullable FBSDKLoginManagerLoginResult *)result error:(nullable NSError *)error {
    NSAssert(error || result, @"Must have a result or an error");
    
    if (error) {
        return NSLog(@"An Error occurred: %@", error.localizedDescription);
    }
}

- (void)loginButtonDidLogOut:(nonnull FBSDKLoginButton *)loginButton {
    [[FBSDKLoginManager new] logOut ];
    [self onLogout];
    NSLog(@"Logged out");
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
