//
//  Task.m
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/13/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import "Subtask.h"

@implementation Subtask

@dynamic text;
@dynamic completed;

+ (nonnull NSString *)parseClassName {
    return @"Subtask";
}

@end
