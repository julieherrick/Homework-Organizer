//
//  ParseUpdateFunctions.m
//  Homework-Organizer
//
//  Created by Julie Herrick on 8/3/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import "ParseUpdateFunctions.h"

@implementation ParseUpdateFunctions

-(void)saveAssignment:(Assignment *)assignment {
    [assignment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"assignment saved");
        } else {
            NSLog(@"error");
        }
    }];
}

-(NSArray<Subtask *>*)fetchParentSubtasks:(Assignment *)assignment {
    PFRelation *relation = [assignment relationForKey:@"Subtask"];
    PFQuery *query = [relation query];
    [query orderByAscending:@"createdAt"];
    __block NSArray *results = @[];
    [query findObjectsInBackgroundWithBlock:^(NSArray<Subtask *>* _Nullable subtasks, NSError * _Nullable error) {
        if (subtasks) {
            results = subtasks;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    return results;
}

-(void)saveParentSubtask:(Subtask *)parentTask {
    [parentTask saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"parent task saved");
        } else {
            NSLog(@"error");
        }
    }];
}

-(NSArray<Subtask *>*)fetchChildSubtasks:(Subtask *)parentTask {
    PFRelation *relation = [parentTask relationForKey:@"Subtask"];
    PFQuery *query = [relation query];
    [query orderByAscending:@"createdAt"];
    __block NSArray *results = @[];
    [query findObjectsInBackgroundWithBlock:^(NSArray<Subtask *>* _Nullable subtasks, NSError * _Nullable error) {
        if (subtasks) {
            results = subtasks;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    return results;
}

-(void)saveChildSubtask:(Subtask *)childTask {
    [childTask saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"child task saved");
        } else {
            NSLog(@"error");
        }
    }];
}

@end
