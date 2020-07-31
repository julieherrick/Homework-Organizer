//
//  DetailsViewController.m
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/13/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import "DetailsViewController.h"
#import "Subtask.h"
#import "SubtaskCell.h"
#import "FullImageViewController.h"
#import "ProgressTracking.h"
#import "AssignmentListCell.h"
@import Parse;

@interface DetailsViewController () <UITableViewDelegate, UITableViewDataSource, ProgressTrackingDelegate>

@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<Subtask *> *subtasks;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *completedButton;
@property (weak, nonatomic) IBOutlet UIImageView *completedIcon;
@property (nonatomic, strong) NSMutableArray<Subtask *> *allSubtasks;

@property int totalSubSubtasks;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self fetchSubtasks];
    [self loadAssignment];
    if (self.assignment.completed) {
        self.completedIcon.alpha = 1;
    } else {
        self.completedIcon.alpha = 0;
    }
    
}

- (IBAction)onChange:(id)sender {
    NSLog(@"Status being changed");
    ProgressTracking *progressTracking = [[ProgressTracking alloc] init];
    progressTracking.delegate = self;
    [progressTracking updateProgress:self.assignment];
//    [self updateCellProgress:self.indexNumber];
}

-(void)updateCellProgress:(NSIndexPath *)indexPath {
    NSLog(@"Updating cell progress...");
    [self.delegate didUpdateCell:indexPath withValue:self.assignment.progress];
}

-(NSUInteger)allSubtasksCapacity {
    NSUInteger count = self.subtasks.count;
    for (Subtask *task in self.subtasks) {
        NSLog(@"count =@%lu", (unsigned long)count);
        if (task.totalChildTasks != nil) {
            NSLog(@"Number of child tasks: @%@", task.totalChildTasks);
            count += [task.totalChildTasks intValue];
        }
    }
    return count;
}

-(void)fetchSubtasks {
    PFRelation *relation = [self.assignment relationForKey:@"Subtask"];
    PFQuery *query = [relation query];
    [query orderByAscending:@"createdAt"];
    //    [query includeKey:@"author"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray* _Nullable subtasks, NSError * _Nullable error) {
        if (subtasks) {
            self.subtasks = (NSMutableArray *) subtasks;;
            //            NSLog(@"%@", self.subtasks);
            //            [self.tableView reloadData];
            NSUInteger listCapacity = [self allSubtasksCapacity];
            self.allSubtasks = [[NSMutableArray alloc] initWithCapacity: listCapacity];
            
            for (int i= 0; i < subtasks.count; i++) {
                Subtask *task = [subtasks objectAtIndex:i];
                NSLog(@"adding @%@", task.subtaskText);
                [self.allSubtasks addObject:task];
                if (task.isParentTask) {
                    //                        [self queryChildTasks:i];
                    PFRelation *subtaskRelation = [task relationForKey:@"Subtask"];
                    PFQuery *subtaskQuery = [subtaskRelation query];
                    [subtaskQuery orderByAscending:@"createdAt"];
                    [subtaskQuery findObjectsInBackgroundWithBlock:^(NSArray<Subtask *>* _Nullable childSubtasks, NSError * _Nullable error) {
                        if (childSubtasks) {
//                            NSLog(@"adding @%@", task.subtaskText);
//                            [self.allSubtasks addObject:task];
                            //                    self.allSubtasks = (NSMutableArray *) subtasks;
//                            [self.allSubtasks addObjectsFromArray:childSubtasks];
                            for (int x = 0; x < childSubtasks.count; x++) {
                                NSLog(@"inserting @%@", [childSubtasks objectAtIndex:x].subtaskText);
                                [self.allSubtasks insertObject: [childSubtasks objectAtIndex:x] atIndex:i+1+self.totalSubSubtasks];
                                self.totalSubSubtasks ++;
                            }
                            [self.tableView reloadData];
                        } else {
                            // handle error
                            NSLog(@"%@", error.localizedDescription);
                        }
                    }];
                }
            }
        } else {
            // handle error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

-(void)fetchAllSubtasks {
//    self.totalSubSubtasks = 0;
    for (int i= 0; i < self.subtasks.count; i++) {
        Subtask *task = [self.subtasks objectAtIndex:i];
        NSLog(@"adding @%@", task.subtaskText);
        if (task.isParentTask) {
//            [self.allSubtasks addObject:task];
            [self queryChildTasks:i];
        } // else {
//            [self.allSubtasks addObject:task];
//        }
    }
//    self.allSubtasks = self.subtasks;
    [self.tableView reloadData];
}

-(void)queryChildTasks:(NSUInteger) i{
    Subtask *task = [self.subtasks objectAtIndex:i];
    PFRelation *relation = [task relationForKey:@"Subtask"];
    PFQuery *query = [relation query];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray<Subtask *>* _Nullable subtasks, NSError * _Nullable error) {
        if (subtasks) {
            [self.allSubtasks addObject:task];
//                    self.allSubtasks = (NSMutableArray *) subtasks;
            [self.allSubtasks addObjectsFromArray:subtasks];
            for (int x = 0; x < subtasks.count; x++) {
                [self.allSubtasks insertObject: [subtasks objectAtIndex:x] atIndex:i+1+self.totalSubSubtasks];
                self.totalSubSubtasks ++;
            }
//            [self.tableView reloadData];
        } else {
            // handle error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
//    [self.tableView reloadData];
}

-(void)loadAssignment {
    self.titleLabel.text = self.assignment.title;
    self.classLabel.text = self.assignment.classKey;
    self.imageView.file = self.assignment.image;
    [self.imageView loadInBackground];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
//    NSString *dateString = [NSString stringWithFormat: @"%@", [formatter stringFromDate:self.assignment.dueDate]];
    self.dueDateLabel.text = [NSString stringWithFormat: @"%@", [formatter stringFromDate:self.assignment.dueDate]];
    
    if (self.assignment.completed) {
        self.completedIcon.alpha = 1;
    }
        
    [self.progressBar setProgress:[self.assignment.progress floatValue]];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
     SubtaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubtaskCell"];
     Subtask *subtask = self.allSubtasks[indexPath.row];
     
     cell.subtask = subtask;
     
     return cell;
 }

 - (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.allSubtasks.count;
 }
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected row number: %ld", (long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)completeAnimation:(double)value {
    [UIView animateWithDuration:.5 animations:^{
        self.completedIcon.alpha = value;
    }];
}


- (IBAction)onCompleted:(id)sender {
    if (self.assignment.completed) {
        self.assignment.completed = NO;
        [self completeAnimation:0];
    } else if (![self.assignment.progress isEqualToNumber:@1]){
        [self alertError:@"Tasks are not all completed"];
    } else {
        self.assignment.completed = YES;
        [self completeAnimation:1];
    }
    [self.assignment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"assignment status: @%@", (self.assignment.completed ? @"Completed" : @"Not Completed"));
        } else {
            NSLog(@"error");
        }
    }];
}

- (void)alertError:(NSString *)errorMessage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:errorMessage preferredStyle:(UIAlertControllerStyleAlert)];
    
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

-(void)didUpdate:(Assignment *)assignment {
    NSLog(@"DETAILSVIEWCONTROLLER: @%@ progress @%@", self.assignment.title, self.assignment.progress);
    [self.progressBar setProgress:[self.assignment.progress floatValue]];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    Assignment *assignment = self.assignment;
    FullImageViewController *fullImageVC = [segue destinationViewController];
    fullImageVC.assignment = assignment;
}



@end
