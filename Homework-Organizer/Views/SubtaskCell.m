//
//  SubtaskCell.m
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/15/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import "SubtaskCell.h"
#import "ProgressTracking.h"

@implementation SubtaskCell

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
    if (subtask.completed) {
        [self.completionButton setImage:[UIImage systemImageNamed:@"checkmark.square.fill"] forState:UIControlStateNormal];
    } else {
        [self.completionButton setImage:[UIImage systemImageNamed:@"square"] forState:UIControlStateNormal];
    }
}


- (IBAction)onComplete:(id)sender {
    if (!self.subtask.completed) {
        self.subtask.completed = YES;
        [self.subtask saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"subtask update completed");
                NSLog(@"Subtask Status: %@", self.subtask.completed ? @"YES" : @"NO");
                [self.completionButton setImage:[UIImage systemImageNamed:@"checkmark.square.fill"] forState:UIControlStateNormal];
            } else {
                NSLog(@"error");
            }
        }];
    } else {
        self.subtask.completed = NO;
        [self.subtask saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"subtask update completed");
                NSLog(@"Subtask Status: %@", self.subtask.completed ? @"YES" : @"NO");
                [self.completionButton setImage:[UIImage systemImageNamed:@"square"] forState:UIControlStateNormal];
            } else {
                NSLog(@"error");
            }
        }];
    }
    
//    DetailsViewController *detailsViewController = [[DetailsViewController alloc] init];
//    ProgressTracking *progressTracking = [[ProgressTracking alloc] init];
//    [progressTracking updateProgress:detailsViewController.assignment];
//    NSLog(@"Progress: %@", detailsViewController.assignment.progress);
//    [detailsViewController.progressBar setProgress:[detailsViewController.assignment.progress floatValue]];
}


@end
