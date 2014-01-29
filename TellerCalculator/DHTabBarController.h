//
//  DHTabBarController.h
//  TellerCalculator
//
//  Created by Derrick Ho on 1/27/14.
//  Copyright (c) 2014 Derrick Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHHistoryModel;

@interface DHTabBarController : UITabBarController

@property (strong, atomic) DHHistoryModel *historyModel;

- (void)segueToBasicCalculatorViewController;

- (void)modifyHistoryModelWithKey:(NSString *)key atRange:(NSRange)range;

@end
