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
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ProgressTracking : UIViewController

@property (nonatomic, strong) Assignment *assignment;

-(void)updateProgress;

@end

NS_ASSUME_NONNULL_END
