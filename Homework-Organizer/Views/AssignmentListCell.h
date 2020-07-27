//
//  AssignmentListCell.h
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/13/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Assignment.h"
#import "ProgressTracking.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssignmentListCell : UITableViewCell

@property (weak, nonatomic) Assignment *assignment;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;




@end

NS_ASSUME_NONNULL_END
