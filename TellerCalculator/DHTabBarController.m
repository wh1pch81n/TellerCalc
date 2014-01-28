//
//  DHTabBarController.m
//  TellerCalculator
//
//  Created by Derrick Ho on 1/27/14.
//  Copyright (c) 2014 Derrick Ho. All rights reserved.
//

#import "DHTabBarController.h"
#import "DHCalculatorBasicViewController.h"
#import "DHHistoryModel.h"

@implementation DHTabBarController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self setDisplayText:@""];
	[self setSelectedIndex:1];
}

- (void)setBasicCalculatorDisplay:(NSString *)text {
	DHCalculatorBasicViewController *BVC = self.viewControllers[1];
	BVC.displayTextField.text = text;
}

- (void)segueToBasicCalculatorViewController {
	self.selectedIndex = 1;
}

@end
