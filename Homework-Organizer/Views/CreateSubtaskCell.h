//
//  CreateSubtaskCell.h
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/22/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Subtask.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateSubtaskCell : UITableViewCell

@property (nonatomic, weak) Subtask *subtask;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

NS_ASSUME_NONNULL_END
