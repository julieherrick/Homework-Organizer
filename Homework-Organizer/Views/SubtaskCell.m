//
//  SubtaskCell.m
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/15/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import "SubtaskCell.h"
#import "ProgressTracking.h"

// design
#import <MaterialComponents/MaterialButtons+ColorThemer.h>
#import <MaterialComponents/MaterialButtons+TypographyThemer.h>

#import <MaterialComponents/MaterialTextFields+ColorThemer.h>
#import <MaterialComponents/MaterialTextFields.h>

#import "MaterialTextFields+Theming.h"
#import "MaterialContainerScheme.h"
#import "MaterialTypographyScheme.h"
#import <MaterialComponents/MaterialButtons.h>
#import <MaterialComponents/MaterialButtons+Theming.h>

#import "ApplicationScheme.h"

@implementation SubtaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)sendAssignment:(Assignment *)assignment {
    self.assignment = assignment;
}

-(Assignment *)getParentAssignment:(Subtask *)task {
    if (!task.isParentTask) {
        return [self getParentAssignment:task.parentTask];
    }
    return task.assignmentParent;
}

-(void)updateComplete {
//    ProgressTracking *progressTracking = [[ProgressTracking alloc] init];
//    progressTracking.delegate = self;
//    Assignment *currentAssignment = [self getParentAssignment:self.subtask];
//    [progressTracking updateProgress:currentAssignment]; 
//    
//    [self.delegate didUpdateTable];
}

-(void)setSubtask:(Subtask *)subtask {
    _subtask = subtask;
    self.descriptionLabel.text = subtask.subtaskText;
    if (subtask.completed) {
        [self.completionButton setImage:[UIImage systemImageNamed:@"checkmark.square.fill"] forState:UIControlStateNormal];
        
    } else {
        [self.completionButton setImage:[UIImage systemImageNamed:@"square"] forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0 animations:^{
        if (subtask.isChildTask) {
            self.leadingConstraint.constant = 32;
//            [self.view layoutIfNeeded];
        } else {
            self.leadingConstraint.constant = 10;
        }
    }];
    
}

-(void)saveStatus:(Subtask *)task withStatus:(BOOL)status {
    task.completed = status;
    NSString *buttonImage = @"square";
    int val = -1;
    if (status) {
        buttonImage = @"checkmark.square.fill";
        val = 1;
    }
    [task saveInBackground];
    [UIView animateWithDuration:0.3 animations:^{
        [self.completionButton setImage:[UIImage systemImageNamed:buttonImage] forState:UIControlStateNormal];
    }];

}


-(void)completeChildren {
    PFRelation *subtaskRelation = [self.subtask relationForKey:@"Subtask"];
    PFQuery *subtaskQuery = [subtaskRelation query];
    [subtaskQuery orderByAscending:@"createdAt"];
    [subtaskQuery whereKey:@"completed" equalTo:@NO]; // only queries children that aren't complete
    [subtaskQuery findObjectsInBackgroundWithBlock:^(NSArray<Subtask *>* _Nullable childSubtasks, NSError * _Nullable error) {
        if (childSubtasks) {
            for (Subtask *task in childSubtasks) {
                task.completed = YES;
                [task saveInBackground];
                if (task.isParentTask) {
                    [self completeChildren];
                }
            }
            [self saveStatus:self.subtask withStatus:YES];
            [self updateComplete];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)onComplete:(id)sender {
    if (!self.subtask.completed) {
        if (self.subtask.isParentTask) {
            // complete all children
            [self completeChildren];
        } else {
            [self saveStatus:self.subtask withStatus: YES];
        }
    } else {
        [self saveStatus:self.subtask withStatus:NO];
    }
}

@end
