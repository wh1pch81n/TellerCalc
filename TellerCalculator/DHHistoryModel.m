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
	NSLog(@"%d_%d %@", index, delAmt, text);
	if (delAmt) {
		if (index == 0) {
			return;
		} else if (index > self.historyString.length) {
			index = self.historyString.length;
		}
		
		//TODO: situation when multiple are highlighted
		
		--index;
	}

	self.historyString = [self.historyString stringByReplacingCharactersInRange:NSMakeRange(index, delAmt) withString:text?:@""];
}

@end
