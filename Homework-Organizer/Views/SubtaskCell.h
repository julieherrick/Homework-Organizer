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

NS_ASSUME_NONNULL_BEGIN

@interface SubtaskCell : UITableViewCell

@property (nonatomic, weak) Subtask *subtask;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *completionButton;


@end

NS_ASSUME_NONNULL_END
