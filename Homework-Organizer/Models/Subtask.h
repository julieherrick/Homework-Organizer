//
//  Task.h
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/13/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import <Parse/Parse.h>
//#import "Assignment.h"
@class Assignment;

NS_ASSUME_NONNULL_BEGIN

@interface Subtask : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *subtaskText; // subtask text
@property (nonatomic) BOOL completed;
@property (nonatomic) BOOL isChildTask;
@property (nonatomic) BOOL isParentTask;
@property (nonatomic) NSNumber *totalChildTasks;
@property (nonatomic) NSNumber *totalCompletedChildTasks;
@property (nonatomic) Subtask *parentTask;
@property (nonatomic) Assignment *assignmentParent;


@end

NS_ASSUME_NONNULL_END
