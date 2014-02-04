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
#import "DHCalculator.h"
#import "DHCalculatorTableViewController.h"

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

	self.tableViewController = self.viewControllers[0];
	self.basicViewController = self.viewControllers[1];
	[self.basicViewController setDelegate:self];
	
	[self.basicViewController displayTextShallObserve:self.historyModel forKeyPath:@"historyString" observedChange:^(NSString *keyPath, id object, UITextField *displayTextField) {
		if ([keyPath isEqualToString:@"historyString"]) {
			NSString *HS = [(DHHistoryModel *)object historyString];
			[displayTextField setText:HS];
		}
	}];
}

- (void)segueToBasicCalculatorViewController {
	self.selectedIndex = 1;
}

- (void)receiveSelectedTableViewObject:(id)object {
	[self.historyModel setHistoryString:[(DHHistoryModel *)object historyString]];
}

- (void)modifyHistoryModelWithKey:(NSString *)key atRange:(NSRange)range{
	NSString *insert = nil;
	
	if ([key isEqualToString:kBackspace]) {
		insert = nil;
		if (range.length == 0) {//unselected
			range.length = -1;
		} else if (range.length > 0) {//selected
			
		}
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
		if ((insert = [[DHCalculator new] CalculatedAnswerAsString:[self cleanString:self.historyModel.historyString]])) {
			[self.tableViewController appendHistory:self object:self.historyModel];
			[self.historyModel setHistoryString:insert];
		} else {
			[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter valid input" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
		}
		return;
	} else if ([key isEqualToString:kPeriod]) {
		NSString *histStr = self.historyModel.historyString;
		if (range.location == 0) {
			insert = @"0.";
		} else if (![self characterAtIndexIsNumber:histStr index:range.location -1]) {
			insert = @"0.";
			if ([histStr characterAtIndex:range.location -1] == '.') {
				return;
			}
		} else {
			//Check if a period exists in this number.
			for (int i = range.location -1; i; --i) {
				if ([histStr characterAtIndex:i] == '.') {
					return;
				} else if (![self characterAtIndexIsNumber:histStr index:i]) {
					break;
				}
			}
			
			insert = @".";
		}
	} else { //Enters a string number
		insert = key;
	}
	
	[self.historyModel spliceHistoryStringAtIndex:range.location selectionAmount:range.length insert:insert];
}

/**
 Determines if the character at the given index is a character or not.
 @param str the given string
 @param index index to check
 @return true if the character x is 0 ≤ x ≤ 9. Otherwise false 
 */
- (BOOL)characterAtIndexIsNumber:(NSString *)str index:(NSUInteger)index {
	return [str characterAtIndex:index] >= '0' && [str characterAtIndex:index] <= '9';
}

/**
 Parses string and replaces characters with DHCalculator compliant symbols.
 x gets replaced with *
 ÷ gets replaced with /
 % gets replaced with *0.01
 @param str The string to be cleaned
 @return the cleaned string.
 */
- (NSString *)cleanString:(NSString *)str {
	return [[[str stringByReplacingOccurrencesOfString:@"x" withString:@"*"]
					 stringByReplacingOccurrencesOfString:@"÷" withString:@"/"]
					stringByReplacingOccurrencesOfString:@"%" withString:@"*0.01"];
}

@end
