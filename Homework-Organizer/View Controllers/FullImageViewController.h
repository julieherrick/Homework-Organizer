//
//  FullImageViewController.h
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/15/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface FullImageViewController : UIViewController

@property (nonatomic, strong) PFImageView *image;

@end

NS_ASSUME_NONNULL_END
