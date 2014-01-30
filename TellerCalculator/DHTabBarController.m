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

NSString *const kBackspace = @"backspace";
NSString *const kLParenthesis = @"leftParenthesis";
NSString *const kRParenthesis = @"rightParenthesis";
NSString *const kPercent = @"percent";
NSString *const kDivide = @"divide";
NSString *const kMultipy = @"multiply";
NSString *const kAdd = @"add";
NSString *const kSubtract = @"subtract";
NSString *const kEquals = @"equals";
NSString *const kPeriod = @"period";
NSString *const k9 = @"9";
NSString *const k8 = @"8";
NSString *const k7 = @"7";
NSString *const k6 = @"6";
NSString *const k5 = @"5";
NSString *const k4 = @"4";
NSString *const k3 = @"3";
NSString *const k2 = @"2";
NSString *const k1 = @"1";
NSString *const k0 = @"0";

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
	NSString *insert = nil;

	if ([key isEqualToString:kBackspace]) {
		insert = nil;
		if (range.length == 0) {range.length = 1;}
	} else if ([key isEqualToString:kLParenthesis]) {
		insert = @"(";
	} else if ([key isEqualToString:kRParenthesis]) {
		insert = @")";
	} else if ([key isEqualToString:kPercent]) {
		insert = @"%";
	} else if ([key isEqualToString:kDivide]) {
		insert = @"÷";
	} else if ([key isEqualToString:kMultipy]) {
		insert = @"x";
	} else if ([key isEqualToString:kAdd]) {
		insert = @"+";
	} else if ([key isEqualToString:kSubtract]) {
		insert = @"-";
	} else if ([key isEqualToString:kEquals]) {
		insert = @"=";//TODO: remove this
		//TODO: should save string into the table
		//TODO: Launch code that Solves the code.  
	} else if ([key isEqualToString:kPeriod]) {
		insert = @".";
	} else {
		insert = key;
	}
	
	[self.historyModel spliceHistoryStringAtIndex:range.location deleteAmount:range.length insert:insert];
}

@end
