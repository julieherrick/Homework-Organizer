//
//  CreateSubtaskViewController.m
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/15/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import "CreateSubtaskViewController.h"
#import "Assignment.h"
#import "Subtask.h"
#import <Parse/Parse.h>
#import "CreateSubtaskCell.h"
#import "CreateSubSubtasksViewController.h"

#import "MaterialTextFields+Theming.h"
#import "MaterialContainerScheme.h"
#import "MaterialTypographyScheme.h"
#import <MaterialComponents/MaterialButtons.h>
#import <MaterialComponents/MaterialButtons+Theming.h>

#import "ApplicationScheme.h"

@interface CreateSubtaskViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic) MDCTextInputControllerOutlined *taskController;
@property (weak, nonatomic) IBOutlet MDCTextField *taskField;

@property (strong, nonatomic) Assignment *assignment;
@property (strong, nonatomic) NSMutableArray<Subtask *> *subtasks;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<Subtask *> *allSubtasks;
@property (weak, nonatomic) IBOutlet MDCFloatingButton *addTaskButton;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *backgroundTaskView;

@end

@implementation CreateSubtaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // TODO: Instantiate Controllers
        MDCContainerScheme *containerScheme = [[MDCContainerScheme alloc] init];
        containerScheme.colorScheme = [ApplicationScheme sharedInstance].colorScheme;
    //    containerScheme.typographyScheme = [ApplicationScheme sharedInstance].typographyScheme;


        self.taskController = [[MDCTextInputControllerOutlined alloc] initWithTextInput:self.taskField];
        self.taskField.placeholder = @"New Task";
        self.taskField.translatesAutoresizingMaskIntoConstraints = NO;
    //    [self styleTextInputController:self.titleController];
        [self.taskController applyThemeWithScheme:containerScheme];
    
    self.addTaskButton = [MDCFloatingButton floatingButtonWithShape:MDCFloatingButtonShapeDefault];
    self.addTaskButton.accessibilityLabel = @"add task";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    PFQuery *query = [PFQuery queryWithClassName:@"Assignment"];
        [query orderByDescending:@"createdAt"];
        query.limit = 1;

        [query findObjectsInBackgroundWithBlock:^(NSArray<Assignment *> * _Nullable assignments, NSError * _Nullable error) {
            if (assignments) {
                self.assignment = assignments[0];
            }
        }];
//    [self.tableView setHidden:YES];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.layer.cornerRadius = 12.0;
    self.topView.layer.cornerRadius = 12.0;
    [self.topView setClipsToBounds:YES];
    self.backgroundTaskView.layer.cornerRadius = 10;
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:nil];
    self.allSubtasks = [[NSMutableArray alloc] init];
//    [self fetchAllSubtasks];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)onNewSubtask:(id)sender {
    
    Subtask *newTask = [Subtask new];
    if ([self.taskField.text isEqual:@""]) {
        [self.taskController setErrorColor:[UIColor colorWithRed:0.87 green:0.29 blue:0.16 alpha:1.0]];
        [self.taskController setErrorText:@"can't create empty task" errorAccessibilityValue:nil];
    } else {
        newTask.subtaskText = self.taskField.text;
        newTask.completed = NO;
        newTask.assignmentParent = self.assignment;
        [self.taskController setErrorColor:[UIColor colorWithRed:0.16 green:0.75 blue:0.87 alpha:1.0]];
        [self.taskController setErrorText:@"" errorAccessibilityValue:nil];
        [newTask saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                PFRelation *relation = [self.assignment relationForKey:@"Subtask"];
                [relation addObject:newTask];
                [self.subtasks addObject:newTask];
                [self.assignment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if(succeeded){
                        int value = 1 + [self.assignment.totalSubtasks intValue];
                        self.assignment.totalSubtasks = [NSNumber numberWithInt:value];
                        
                        NSLog(@"success: %d %@", value, @" subtasks");
                        self.taskField.text = @"";
                        [self fetchSubtasks];
//                        [self insertNewSubtask];
                    }
                }];
            } else {
                NSLog(@"subtask not updated");
            }
        }];
    }
}


//-(void)insertNewSubtask {
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.assignment.totalSubtasks intValue]-1 inSection:0];
////    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
//    NSLog(@"Subtask Count @%d", ([self.assignment.totalSubtasks intValue]-1));
//    [self.tableView beginUpdates];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.tableView endUpdates];
//
//    self.taskField.text = @"";
//}


- (IBAction)onCompletion:(id)sender {
    // creationComplete will be marked true on page where subtasks are added
    // assignment feed can use this to only query assignments that are complete with subtasks
    if (self.subtasks) {
        self.assignment.creationComplete = YES;
        NSLog(@"%@", self.assignment.creationComplete ? @"YES" : @"NO");
        [self.assignment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"assignment creation completed");
                [self performSegueWithIdentifier:@"create" sender:nil];
            } else {
                NSLog(@"error");
            }
        }];
    } else {
        [self.taskController setErrorColor:[UIColor colorWithRed:0.87 green:0.29 blue:0.16 alpha:1.0]];
        [self.taskController setErrorText:@"must have at least one task" errorAccessibilityValue:nil];
    }
}

-(void)fetchAllSubtasks {
    for (Subtask *task in self.subtasks) {
        [self.allSubtasks addObject:task];
        if (task.isParentTask) {
            PFRelation *relation = [task relationForKey:@"Subtask"];
            PFQuery *query = [relation query];
            [query orderByAscending:@"createdAt"];
            [query findObjectsInBackgroundWithBlock:^(NSArray<Subtask *>* _Nullable subtasks, NSError * _Nullable error) {
                if (subtasks) {
//                    self.allSubtasks = (NSMutableArray *) subtasks;
                    [self.allSubtasks addObjectsFromArray:subtasks];
                    [self.tableView reloadData];
                } else {
                    // handle error
                    NSLog(@"%@", error.localizedDescription);
                }
            }];
        }
        self.allSubtasks = self.subtasks;
        [self.tableView reloadData];
    }
}

-(void)fetchSubtasks {
    PFRelation *relation = [self.assignment relationForKey:@"Subtask"];
    PFQuery *query = [relation query];
    [query orderByAscending:@"createdAt"];
//    [query includeKey:@"author"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray<Subtask *>* _Nullable subtasks, NSError * _Nullable error) {
        if (subtasks) {
            self.subtasks = (NSMutableArray *) subtasks;
            if ([self.subtasks count] == 0) {
                [self.tableView setHidden:YES];
            } else {
                [self.tableView setHidden:NO];
            }
            [self.tableView reloadData];
//            [self fetchAllSubtasks];
        } else {
            // handle error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
     CreateSubtaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateSubtaskCell"];
     Subtask *subtask = self.subtasks[indexPath.row];
     
     cell.subtask = subtask;
     
     return cell;
 }

 - (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.subtasks.count;
 }
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected row number: %ld", (long)indexPath.row);
//    [self performSegueWithIdentifier:@"subSubtaskSegue" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [tableView reloadData];
}

- (void)alertError:(NSString *)errorMessage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessage preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // closes to let the user fill the fields
    }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if(![[segue identifier] isEqualToString:@"create"]) {
        CreateSubtaskCell *tappedCell = sender;
        NSIndexPath *myindexPath = [self.tableView indexPathForCell:tappedCell];
        NSLog(@"Subtask: @%@", self.subtasks[myindexPath.row].subtaskText);
        Subtask *subtask = self.subtasks[myindexPath.row];
//        Subtask *subtask = self.subtasks[[self.tableView indexPathForCell:tappedCell].row];
        CreateSubSubtasksViewController *createSubSubtasks = [segue destinationViewController];
        createSubSubtasks.subtask = subtask;
        
        NSLog(@"Tapping on a subtask!");
    }
}

@end
