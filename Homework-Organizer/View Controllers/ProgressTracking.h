//
//  ProgressTracking.h
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/23/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Assignment.h"
#import "Subtask.h"
#import "DetailsViewController.h"
#import "AssignmentListCell.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@protocol ProgressTrackingDelegate <NSObject>

@optional

- (void)didUpdate:(Assignment *)assignment;             

@end

@interface ProgressTracking : UIViewController

@property (weak, nonatomic) id<ProgressTrackingDelegate> delegate;

-(void)updateProgress:(Assignment *) assignment;

@end

NS_ASSUME_NONNULL_END
