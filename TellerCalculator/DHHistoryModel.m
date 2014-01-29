//
//  DHHistoryModel.m
//  TellerCalculator
//
//  Created by Derrick Ho on 1/27/14.
//  Copyright (c) 2014 Derrick Ho. All rights reserved.
//

#import "DHHistoryModel.h"

@implementation DHHistoryModel

- (id)initWithString:(NSString *)str {
	if (self = [super init]) {
		[self setHistoryString:str];
	}
	return self;
}

- (id)init {
	return [self initWithString:@""];
}

- (DHHistoryModel *)duplicate {
	return [self initWithString:self.historyString];
}

- (void)spliceHistoryStringAtIndex:(NSUInteger)index deleteAmount:(NSUInteger)delAmt insert:(NSString *)text {
	//handel deletions
	self.historyString = [self.historyString stringByReplacingCharactersInRange:NSMakeRange(index, delAmt) withString:@""];
	
	//handel insertions
	self.historyString = [self.historyString stringByReplacingCharactersInRange:NSMakeRange(index, 0) withString:text?:@""];
}

@end
