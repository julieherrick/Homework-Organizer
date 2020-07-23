//
//  CreateSubtaskCell.m
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/22/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import "CreateSubtaskCell.h"

@implementation CreateSubtaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setSubtask:(Subtask *)subtask {
    _subtask = subtask;
    self.descriptionLabel.text = subtask.subtaskText;
//    if (subtask.completed) {
//        [self.completionButton setImage:[UIImage systemImageNamed:@"checkmark.square.fill"] forState:UIControlStateNormal];
//    } else {
//        [self.completionButton setImage:[UIImage systemImageNamed:@"square"] forState:UIControlStateNormal];
//    }
}

@end
