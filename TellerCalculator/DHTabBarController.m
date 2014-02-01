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
}

- (void)segueToBasicCalculatorViewController {
	self.selectedIndex = 1;
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
		//insert = @"=";//TODO: remove this
		//TODO: should save string into the table iff it is a valid equation
		//TODO: Launch code that Solves the code.
		if ((insert = [[DHCalculator new] CalculatedAnswerAsString:self.historyModel.historyString])) {
			[self.tableViewController appendHistory:self object:self.historyModel];
			[self.historyModel setHistoryString:insert];
		} else {
			[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter valid input" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
		}
		return;
	} else if ([key isEqualToString:kPeriod]) {
		insert = @".";
		//TODO: implement some corrective logic just like before
		/*snippit from old code
		 - (IBAction)pushPeriod:(id)sender {
		 //doesn't prevent 0.0.0 from being entered.  Doesn't appear to cause problems
		 //but it is worth noting at least
		 NSString* text = [[self TextField]text];
		 if ( [text isEqualToString:@""] ||
		 [text characterAtIndex:text.length-1] == 'x'||
		 [[text substringWithRange:NSMakeRange(text.length-1, 1)]isEqualToString:@"÷"]||
		 [text characterAtIndex:text.length-1] == '+'||
		 [text characterAtIndex:text.length-1] == '-') {
		 [self.TextField setText:[text stringByAppendingString:@"0."]];
		 }else if([text characterAtIndex:text.length-1] >= '0' &&
		 [text characterAtIndex:text.length-1] <= '9'){
		 [self.TextField setText:[text stringByAppendingString:@"."]];
		 }
		 }
		 
		 */
	} else {
		insert = key;
	}
	
	[self.historyModel spliceHistoryStringAtIndex:range.location selectionAmount:range.length insert:insert];
}

@end
