//
//  DHTabBarController.h
//  TellerCalculator
//
//  Created by Derrick Ho on 1/27/14.
//  Copyright (c) 2014 Derrick Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHTabBarController : UITabBarController

@property (strong, atomic) NSString *displayText;

- (void)setBasicCalculatorDisplay:(NSString *)text;

- (void)segueToBasicCalculatorViewController;

@end
