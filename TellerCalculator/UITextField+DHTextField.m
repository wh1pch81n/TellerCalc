//
//  UITextField+DHTextField.m
//  TellerCalculator
//
//  Created by Derrick Ho on 1/29/14.
//  Copyright (c) 2014 Derrick Ho. All rights reserved.
//

#import "UITextField+DHTextField.h"

@implementation UITextField (DHTextField)

- (void)setSelectedRange:(NSRange)selectedRange
{
	UITextPosition* from = [self positionFromPosition:self.beginningOfDocument offset:selectedRange.location];
	UITextPosition* to = [self positionFromPosition:from offset:selectedRange.length];
	self.selectedTextRange = [self textRangeFromPosition:from toPosition:to];
}

- (NSRange)selectedRange
{
	UITextRange* range = self.selectedTextRange;
	NSInteger location = [self offsetFromPosition:self.beginningOfDocument toPosition:range.start];
	NSInteger length = [self offsetFromPosition:range.start toPosition:range.end];
	NSAssert(location >= 0, @"Location is valid.");
	NSAssert(length >= 0, @"Length is valid.");
	return NSMakeRange(location, length);
}

@end
