//
//  ApplicationScheme.h
//  Homework-Organizer
//
//  Created by Julie Herrick on 8/4/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MaterialButtons.h"
#import <MaterialComponents/MaterialButtons+Theming.h>
#import <MaterialComponents/MaterialColorScheme.h>
#import <MaterialComponents/MaterialTypographyScheme.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApplicationScheme : NSObject

+ (instancetype)sharedInstance;
- (instancetype)init NS_UNAVAILABLE;

@property(nonnull, readonly, nonatomic) MDCSemanticColorScheme *colorScheme;
@property(nonnull, readonly, nonatomic) MDCTypographyScheme *typographyScheme;
@property(nonnull, readonly, nonatomic) MDCContainerScheme *buttonScheme;

@end

NS_ASSUME_NONNULL_END
