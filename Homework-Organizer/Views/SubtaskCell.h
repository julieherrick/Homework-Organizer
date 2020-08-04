//
//  SubtaskCell.h
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/15/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Subtask.h"
#import "DetailsViewController.h"
#import "ProgressTracking.h"
#import "Assignment.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SubtaskCellDelegate <NSObject>

@optional

-(void)didUpdateTable;

@end

@interface SubtaskCell : UITableViewCell <ProgressTrackingDelegate>

@property (weak, nonatomic) id<SubtaskCellDelegate> delegate;

-(void)sendAssignment:(Assignment *)assignment;

@property (nonatomic, weak) Subtask *subtask;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *completionButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraint;
@property(weak, nonatomic) Assignment *assignment;


@end

NS_ASSUME_NONNULL_END
