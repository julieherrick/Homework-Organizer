//
//  Assignment.m
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/13/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import "Assignment.h"

@implementation Assignment

@dynamic assignmentID;
@dynamic userID;
//@dynamic author;
@dynamic title;
@dynamic classKey;
@dynamic dueDate;
@dynamic progress;
@dynamic completed;
@dynamic image;

+ (nonnull NSString *)parseClassName {
    return @"Assignment";
}


+ (void) createNewAssignment: ( NSString * _Nullable )title withClassName: ( NSString * _Nullable )className withDueDate: ( NSDate * _Nullable )dueDate withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    Assignment *newAssignment = [Assignment new];
//    newAssignment.author = [PFUser currentUser];
    newAssignment.title = title;
    newAssignment.classKey = className;
    newAssignment.dueDate = dueDate;
    newAssignment.progress = @(0);
//    newAssignment.completed = false;
//    newAssignment.image = [self getPFFileFromImage:image];
    [newAssignment saveInBackgroundWithBlock: completion];
}
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}
 



@end
