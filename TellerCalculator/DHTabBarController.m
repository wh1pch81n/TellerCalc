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
	[self setHistoryModel:[DHHistoryModel new]];
	[self setSelectedIndex:1];
}

- (void)segueToBasicCalculatorViewController {
	self.selectedIndex = 1;
}

- (void)modifyHistoryModelWithKey:(NSString *)key atRange:(NSRange)range{
	if ([key isEqualToString:@"backspace"]) {
		NSLog(@"%d %d", range.location, range.length);
		[self.historyModel spliceHistoryStringAtIndex:range.location deleteAmount:range.length insert:nil];
	}
}

@end
