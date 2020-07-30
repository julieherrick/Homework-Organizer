//
//  Task.m
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/13/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import "Subtask.h"

@implementation Subtask

@dynamic subtaskText;
@dynamic completed;
@dynamic isChildTask;
@dynamic totalChildTasks;
@dynamic totalCompletedChildTasks;
@dynamic isParentTask;

+ (nonnull NSString *)parseClassName {
    return @"Subtask";
}

//+ (void)createNewSubtask:(NSString *)text withRelationship: (BOOL *)isChild {
//    Subtask *newSubtask = [Subtask new];
//    newSubtask.subtaskText = text;
//    newSubtask.isChildTask = isChild;
//}


@end
