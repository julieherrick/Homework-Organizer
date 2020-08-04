//
//  CreateSubSubtasksViewController.m
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/29/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import "CreateSubSubtasksViewController.h"
#import "CreateSubtaskCell.h"

@interface CreateSubSubtasksViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *taskField;
@property (strong, nonatomic) NSMutableArray *subtasks;
@property (weak, nonatomic) IBOutlet UILabel *parentTaskLabel;



@end

@implementation CreateSubSubtasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.parentTaskLabel.text = self.subtask.subtaskText;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.subtask.totalChildTasks = self.subtask.totalChildTasks;
    
    [self fetchSubtasks];
}

- (IBAction)onNewSubtask:(id)sender {
    
    Subtask *newTask = [Subtask new];
    if ([self.taskField.text isEqual:@""])
    {
//        [self alertError:@"cannot create empty subtask"];
    } else {
        newTask.subtaskText = self.taskField.text;
        newTask.isChildTask = YES;
        newTask.parentTask = self.subtask;
        newTask.completed = NO;
        NSLog(@"@%@", newTask.parentTask.subtaskText);
        [newTask saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                PFRelation *relation = [self.subtask relationForKey:@"Subtask"];
                [relation addObject:newTask];
                [self.subtasks addObject:newTask];
                int value = 1 + [self.subtask.totalChildTasks intValue];
                self.subtask.totalChildTasks = [NSNumber numberWithInt:value];
                self.subtask.isParentTask = YES;
                self.subtask.totalCompletedChildTasks = @0;
                
                [self.subtask saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if(succeeded){
                        
                        NSLog(@"success: %d %@", value, @" subtasks");
                        self.taskField.text = @"";
                        [self fetchSubtasks];
//                        [self insertNewSubtask];
                    }else {
                        int value = [self.subtask.totalChildTasks intValue] - 1;
                        self.subtask.totalChildTasks = [NSNumber numberWithInt:value];
                    }
                }];
            } else {
                NSLog(@"subtask not updated");
            }
        }];
    }
}

-(void)fetchSubtasks {
    PFRelation *relation = [self.subtask relationForKey:@"Subtask"];
    PFQuery *query = [relation query];
    [query orderByAscending:@"createdAt"];
//    [query includeKey:@"author"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray<Subtask *>* _Nullable subtasks, NSError * _Nullable error) {
        if (subtasks) {
            self.subtasks = (NSMutableArray *) subtasks;
//            if ([self.subtasks count] == 0) {
//                [self.tableView setHidden:YES];
//            } else {
//                [self.tableView setHidden:NO];
//            }
            [self.tableView reloadData];
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
    [self performSegueWithIdentifier:@"subSubtaskSegue" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [tableView reloadData];
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
