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

@property (strong, nonatomic) Assignment *assignment;
@property (strong, nonatomic) NSMutableArray *subtasks;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onAdd:(id)sender {
    // test to see if assignment is created
    [Assignment  createNewAssignment: @"New Title" withClassName: @"new class!" withDueDate:[NSDate date] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"The assignment was saved!");
            
        } else {
            NSLog(@"Problem saving assignment: %@", error.localizedDescription);
//            [self alertError:error.localizedDescription];
        }
    }];
}
- (IBAction)onSubtask:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Assignment"];
    [query orderByDescending:@"createdAt"];
    query.limit = 1;

    [query findObjectsInBackgroundWithBlock:^(NSArray<Assignment *> * _Nullable assignments, NSError * _Nullable error) {
        if (assignments) {
            // do something with the data fetched
            self.assignment = assignments[0];
//            NSLog(@"%@", self.assignment.title);
        }
    }];
//    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable newestAssignment, NSError * _Nullable error) {
//        self.assignment = (Assignment *) newestAssignment;
////        NSLog(@"%@", newestAssignment.title);
//    }];
    
    Subtask *newTask = [Subtask new];
    newTask.text = @"Updated test task";
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
