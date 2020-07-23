//
//  ProgressTracking.m
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/23/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import "ProgressTracking.h"

@interface ProgressTracking ()

@property (nonatomic, strong) NSMutableArray *subtasks;

@end

@implementation ProgressTracking

-(void)updateProgress:(Assignment *)assignment {
    [self fetchSubtasks:assignment];
//    int completedCount = 0;
//    for (Subtask *task in self.subtasks) {
//        if (task.completed == YES) {
//            completedCount++;
//        }
//    }
//    float progress = completedCount/[assignment.totalSubtasks floatValue];
//    assignment.progress = [NSNumber numberWithFloat:progress];
//    NSLog(@"@%f", progress);
//    [assignment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        if (succeeded) {
//            NSLog(@"assignment progress is updated");
//        } else {
//            NSLog(@"error");
//        }
//    }];
}

-(void)fetchSubtasks:(Assignment *)assignment {
    PFRelation *relation = [assignment relationForKey:@"Subtask"];
    PFQuery *query = [relation query];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray* _Nullable subtasks, NSError * _Nullable error) {
        if (subtasks) {
            self.subtasks = (NSMutableArray *) subtasks;
            int completedCount = 0;
            for (Subtask *task in self.subtasks) {
                if (task.completed == YES) {
                    completedCount++;
                }
            }
            float progress = completedCount/[assignment.totalSubtasks floatValue];
            assignment.progress = [NSNumber numberWithFloat:progress];
            NSLog(@"@%f", progress);
            [assignment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    NSLog(@"assignment progress is updated");
                } else {
                    NSLog(@"error");
                }
            }];
             } else {
                // handle error
                NSLog(@"%@", error.localizedDescription);
            }
             }];
        }


@end
