//
//  ParseUpdateFunctions.h
//  Homework-Organizer
//
//  Created by Julie Herrick on 8/3/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Assignment.h"
#import "Subtask.h"
#import "DetailsViewController.h"
#import "AssignmentListCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ParseUpdateFunctionsDelegate <NSObject>

@optional

- (void)didUpdate;

@end

@interface ParseUpdateFunctions : NSObject

-(void)saveAssignment:(Assignment *)assignment;

-(NSArray<Subtask *>*)fetchParentSubtasks:(Assignment *)assignment;
-(void)saveParentSubtask:(Subtask *)parentTask;

-(NSArray<Subtask *>*)fetchChildSubtasks:(Subtask *)parentTask;
-(void)saveChildSubtask:(Subtask *)childTask;


@end


NS_ASSUME_NONNULL_END
