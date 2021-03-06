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
		[self setHistoryString:str?:@""];
	}
	return self;
}

- (id)init {
	return [self initWithString:nil];
}

- (DHHistoryModel *)duplicate {
	DHHistoryModel *newInstance = [[[self class] alloc] init];
	[newInstance setHistoryString:self.historyString];
	return newInstance;
}

- (void)spliceHistoryStringAtIndex:(NSUInteger)index selectionAmount:(NSUInteger)selAmt insert:(NSString *)text {
	NSLog(@"%d_%d %@", index, selAmt, text);

	if (index > self.historyString.length) {
		index = self.historyString.length;
	}
	
	switch (selAmt) {
		case -1:
			if (index == 0) {
				return;
			}
			index--;
			selAmt = -selAmt;
			break;
		case 0:
			break;
		default:
			break;
	}

	self.historyString = [self.historyString stringByReplacingCharactersInRange:NSMakeRange(index, selAmt) withString:text?:@""];
}

@end
