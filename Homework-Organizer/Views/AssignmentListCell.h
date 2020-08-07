//
//  AssignmentListCell.h
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/13/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Assignment.h"
#import "DetailsViewController.h"

// theme items
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

NS_ASSUME_NONNULL_BEGIN

@interface AssignmentListCell : UITableViewCell

//-(void)updateProgressBar:(NSNumber *)percentage;

@property (weak, nonatomic) Assignment *assignment;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;




@end

NS_ASSUME_NONNULL_END
