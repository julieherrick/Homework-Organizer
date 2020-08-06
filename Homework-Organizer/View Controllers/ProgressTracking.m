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
}

-(void)fetchSubtasks:(Assignment *)assignment {
    PFRelation *relation = [assignment relationForKey:@"Subtask"];
    PFQuery *query = [relation query];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray* _Nullable subtasks, NSError * _Nullable error) {
        if (subtasks) {
            self.subtasks = (NSMutableArray *) subtasks;
            [self setProgressValue:assignment];
        }
    }];
}

-(void)setProgressValue:(Assignment *)assignment {
    int completedCount = 0;
    for (Subtask *task in self.subtasks) {
        if (task.completed == YES) {
            completedCount++;
        }
    }
    [assignment fetchIfNeeded];
    float progress = completedCount/[assignment.totalSubtasks floatValue];
    assignment.progress = [NSNumber numberWithFloat:progress];
    [assignment saveInBackground];
    NSLog(@"PROGRESSTRACKING:@%@ progress updated to @%@", assignment.title, assignment.progress);
    [self.delegate didUpdate:assignment];

}



@end
