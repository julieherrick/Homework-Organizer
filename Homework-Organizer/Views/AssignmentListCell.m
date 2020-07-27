//
//  AssignmentListCell.m
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/13/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import "AssignmentListCell.h"

@implementation AssignmentListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAssignment:(Assignment *)assignment {
    _assignment = assignment;
    self.titleLabel.text = assignment.title;
    self.classLabel.text = assignment.classKey;
//    self.dueDateLabel.text = assignment.dueDate.timeAgoSinceNow;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, yyyy"];
    NSString *dateString = [NSString stringWithFormat: @"%@", [formatter stringFromDate:assignment.dueDate]];
    self.dueDateLabel.text = [dateString substringToIndex:[dateString length]-6];
//    ProgressTracking *progressTracking = [[ProgressTracking alloc] init];
//    [progressTracking updateCellBarProgress:self.assignment];
    [self.progressBar setProgress:[self.assignment.progress floatValue]];
}

@end
