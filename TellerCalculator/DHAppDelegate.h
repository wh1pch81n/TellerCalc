//
//  DHAppDelegate.h
//  TellerCalculator
//
//  Created by Derrick Ho on 5/17/13.
//  Copyright (c) 2013 Derrick Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHCalculatorTableViewCoreData;

@interface DHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;
@property (readonly, strong, nonatomic) DHCalculatorTableViewCoreData *tableViewCoreData;

@end
