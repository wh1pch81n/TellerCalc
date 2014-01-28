//
//  DHCalculatorBasicViewController.m
//  TellerCalculator
//
//  Created by Derrick Ho on 1/27/14.
//  Copyright (c) 2014 Derrick Ho. All rights reserved.
//

#import "DHCalculatorBasicViewController.h"
#import "DHTabBarController.h"

@implementation DHCalculatorBasicViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	//TODO add KVO here so that when the tabbar's value changes it can change the display's text right away.  For now update the display by hand in the viewdidAppear
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	DHTabBarController *tabBarController = (DHTabBarController *)self.tabBarController;
	[self.displayTextField setText:tabBarController.displayText];
}

@end
