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

//- (void) layoutSubviews {
//    [super layoutSubviews];
//
//    CGRect newFrame = UIEdgeInsetsInsetRect(self.layer.frame, UIEdgeInsetsMake(2, 0, 2, 0));
//    self.layer.frame = newFrame;
//}

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
    [self.progressBar setProgress:[assignment.progress floatValue]];
    self.progressBar.layer.cornerRadius = 5;
    self.progressBar.clipsToBounds = YES;
    if (assignment.completed) {
        self.progressBar.tintColor = [UIColor colorWithRed:0.16 green:0.87 blue:0.65 alpha:1.0];
    } else {
        self.progressBar.tintColor = [UIColor colorWithRed:0.16 green:0.75 blue:0.87 alpha:1.0];
    }
    /*
     _colorScheme.primaryColor = [UIColor colorWithRed:0.16 green:0.75 blue:0.87 alpha:1.0];
     _colorScheme.primaryColorVariant = [UIColor colorWithRed:0.00 green:0.56 blue:0.68 alpha:1.0];
     _colorScheme.secondaryColor = [UIColor colorWithRed:0.16 green:0.87 blue:0.65 alpha:1.0];
     */
}

//-(void)updateProgressBar:(NSNumber *)percentage {
//    [self.progressBar setProgress:[percentage floatValue]];
//}

@end
