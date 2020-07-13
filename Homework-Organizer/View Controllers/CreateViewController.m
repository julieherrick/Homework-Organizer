//
//  CreateViewController.m
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/13/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import "CreateViewController.h"
#import "Assignment.h"
#import "Subtask.h"
#import <Parse/Parse.h>

@interface CreateViewController ()

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onAdd:(id)sender {
    // test to see if assignment is created
    [Assignment  createNewAssignment:@"Title" withClassName:@"Class Name" withDueDate:[NSDate date] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"The assignment was saved!");
            
        } else {
            NSLog(@"Problem saving assignment: %@", error.localizedDescription);
//            [self alertError:error.localizedDescription];
        }
    }];
}
- (IBAction)onSubtask:(id)sender {
    Subtask *newTask = [Subtask new];
    newTask.text = @"task text";
    [newTask saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"success");
            PFRelation *relation = [self.assignment relationForKey:@"Subtask"];
            [relation addObject:newTask];
            [self.assignment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(succeeded){
                    NSLog(@"success");
                }
            }];
        } else {
            NSLog(@"subtask not updated");
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

@end
