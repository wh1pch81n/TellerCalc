//
//  DHTabBarController.h
//  TellerCalculator
//
//  Created by Derrick Ho on 1/27/14.
//  Copyright (c) 2014 Derrick Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@interface DHTabBarController : UITabBarController

@property (strong, atomic) DHHistoryModel *historyModel;

/**
 Child viewControllers can call this function to tell the tabbarviewcontroller to move to the basicCalculatorView
 */
- (void)segueToBasicCalculatorViewController;

/**
 Method recieves input from the basicCalculatorView's buttons and reacts accordingly
 @param key
 @param range The location property marks position of the caret (0 being before the first character and str.length and greater being after the last character). The length property counts how many characters are highlighted.
 */
- (void)modifyHistoryModelWithKey:(NSString *)key atRange:(NSRange)range;

@end
