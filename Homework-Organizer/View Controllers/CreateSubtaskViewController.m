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

@interface CreateSubtaskViewController ()
@property (weak, nonatomic) IBOutlet UITextField *taskField;

@property (strong, nonatomic) Assignment *assignment;
@property (strong, nonatomic) NSMutableArray *subtasks;


@end

@implementation CreateSubtaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFQuery *query = [PFQuery queryWithClassName:@"Assignment"];
        [query orderByDescending:@"createdAt"];
        query.limit = 1;

        [query findObjectsInBackgroundWithBlock:^(NSArray<Assignment *> * _Nullable assignments, NSError * _Nullable error) {
            if (assignments) {
                self.assignment = assignments[0];
            }
        }];
}

- (IBAction)onNewSubtask:(id)sender {
    
    Subtask *newTask = [Subtask new];
    newTask.text = self.taskField.text;
    [newTask saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            PFRelation *relation = [self.assignment relationForKey:@"Subtask"];
            [relation addObject:newTask];
            [self.assignment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(succeeded){
                    int value = 1 + [self.assignment.totalSubtasks intValue];
                    self.assignment.totalSubtasks = [NSNumber numberWithInt:value];
                    
                    NSLog(@"success: %d %@", value, @" subtasks");
                    self.taskField.text = @"";
                    
                }
            }];
        } else {
            NSLog(@"subtask not updated");
        }
    }];
}


- (IBAction)onCompletion:(id)sender {
    // creationComplete will be marked true on page where subtasks are added
    // assignment feed can use this to only query assignments that are complete with subtasks
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
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/*
 
 */
@end
