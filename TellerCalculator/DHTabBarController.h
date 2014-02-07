//
//  DHTabBarController.h
//  TellerCalculator
//
//  Created by Derrick Ho on 1/27/14.
//  Copyright (c) 2014 Derrick Ho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHCalculatorBasicViewController.h"
#import "DHCalculatorTableViewController.h"

extern NSString *const kBackspace;
extern NSString *const kLParenthesis;
extern NSString *const kRParenthesis;
extern NSString *const kPercent;
extern NSString *const kDivide;
extern NSString *const kMultipy;
extern NSString *const kAdd;
extern NSString *const kSubtract;
extern NSString *const kEquals;
extern NSString *const kPeriod;
extern NSString *const k9;
extern NSString *const k8;
extern NSString *const k7;
extern NSString *const k6;
extern NSString *const k5;
extern NSString *const k4;
extern NSString *const k3;
extern NSString *const k2;
extern NSString *const k1;
extern NSString *const k0;


@class DHHistoryModel;
@class DHCalculatorTableViewController;

@interface DHTabBarController : UITabBarController <DHCalculatorBasicViewDelegate, DHCalculatorTableViewControllerDelegate>

@property (strong, atomic) DHHistoryModel *historyModel;
@property (strong, atomic) DHCalculatorTableViewController *tableViewController;
@property (strong, atomic) DHCalculatorBasicViewController *basicViewController;

/**
 Child viewControllers can call this function to tell the tabbarviewcontroller to move to the basicCalculatorView
 */
- (void)segueToBasicCalculatorViewController;

@end
