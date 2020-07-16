//
//  Assignment.h
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/13/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import <Parse/Parse.h>
#import "Subtask.h"

NS_ASSUME_NONNULL_BEGIN

@interface Assignment : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *assignmentID;
@property (nonatomic, strong) NSString *userID;
//@property (nonatomic, strong) PFUser *author;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *classKey;
@property (nonatomic, strong) NSDate *dueDate;
@property (nonatomic, strong) NSNumber *progress;
@property (nonatomic) BOOL completed;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic) BOOL creationComplete;
@property (nonatomic, strong) NSNumber *totalSubtasks;
@property (nonatomic, strong) NSNumber *totalCompletedSubtasks;

+ (void) createNewAssignment: ( NSString * _Nullable )title withClassName: ( NSString * _Nullable )className withDueDate: ( NSDate * _Nullable )dueDate withImage:( UIImage * _Nullable )image withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
