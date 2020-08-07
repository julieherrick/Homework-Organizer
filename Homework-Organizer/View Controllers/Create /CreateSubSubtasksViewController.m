//
//  CreateSubSubtasksViewController.m
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/29/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import "CreateSubSubtasksViewController.h"
#import "CreateSubtaskCell.h"

#import "MaterialTextFields+Theming.h"
#import "MaterialContainerScheme.h"
#import "MaterialTypographyScheme.h"
#import <MaterialComponents/MaterialButtons.h>
#import <MaterialComponents/MaterialButtons+Theming.h>

#import "ApplicationScheme.h"

@interface CreateSubSubtasksViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic) MDCTextInputControllerOutlined *taskController;
@property (weak, nonatomic) IBOutlet MDCTextField *taskField;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *subtasks;
@property (weak, nonatomic) IBOutlet UILabel *parentTaskLabel;
@property (weak, nonatomic) IBOutlet MDCFloatingButton *addSubTaskButton;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *taskBackgroundView;

@end

@implementation CreateSubSubtasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MDCContainerScheme *containerScheme = [[MDCContainerScheme alloc] init];
        containerScheme.colorScheme = [ApplicationScheme sharedInstance].colorScheme;
    //    containerScheme.typographyScheme = [ApplicationScheme sharedInstance].typographyScheme;


        self.taskController = [[MDCTextInputControllerOutlined alloc] initWithTextInput:self.taskField];
        self.taskField.placeholder = @"New Subtask";
        self.taskField.translatesAutoresizingMaskIntoConstraints = NO;
    //    [self styleTextInputController:self.titleController];
        [self.taskController applyThemeWithScheme:containerScheme];
    
    self.addSubTaskButton = [MDCFloatingButton floatingButtonWithShape:MDCFloatingButtonShapeDefault];
    self.addSubTaskButton.accessibilityLabel = @"add subtask";
    
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.parentTaskLabel.text = self.subtask.subtaskText;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.subtask.totalChildTasks = self.subtask.totalChildTasks;
    
    self.tableView.layer.cornerRadius = 12.0;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.topView.layer.cornerRadius = 12.0;
    self.taskBackgroundView.layer.cornerRadius = 10;
    
    [self fetchSubtasks];
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
        newTask.isChildTask = YES;
        newTask.parentTask = self.subtask;
        newTask.completed = NO;
        [self.taskController setErrorColor:[UIColor colorWithRed:0.16 green:0.75 blue:0.87 alpha:1.0]];
        [self.taskController setErrorText:@"" errorAccessibilityValue:nil];
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
