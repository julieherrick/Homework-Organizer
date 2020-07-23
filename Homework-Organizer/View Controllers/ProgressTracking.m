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

-(void)updateProgress {
    [self fetchSubtasks];
    int completedCount = 0;
    for (Subtask *task in self.subtasks) {
        if (task.completed == YES) {
            completedCount++;
        }
    }
    float progress = completedCount/[self.assignment.totalSubtasks floatValue];
    self.assignment.progress = [NSNumber numberWithFloat:progress];
}

-(void)fetchSubtasks {
    PFRelation *relation = [self.assignment relationForKey:@"Subtask"];
    PFQuery *query = [relation query];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray* _Nullable subtasks, NSError * _Nullable error) {
        if (subtasks) {
            self.subtasks = (NSMutableArray *) subtasks;;
        } else {
            // handle error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


@end
