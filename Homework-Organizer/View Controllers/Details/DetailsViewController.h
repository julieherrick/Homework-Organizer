//
//  DetailsViewController.h
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/13/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Assignment.h"
#import "ProgressTracking.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DetailsViewControllerDelegate <NSObject>

@optional

-(void)didUpdateCell:(NSIndexPath *)indexPath withValue: (NSNumber *)percentage;

@end

@interface DetailsViewController : UIViewController

@property (weak, nonatomic) id<DetailsViewControllerDelegate> delegate;

-(void)updateCellProgress:(NSIndexPath *)indexPath;

@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
@property (nonatomic, strong) Assignment *assignment;
//@property (nonatomic, strong) NSIndexPath *indexNumber;

@end

NS_ASSUME_NONNULL_END
