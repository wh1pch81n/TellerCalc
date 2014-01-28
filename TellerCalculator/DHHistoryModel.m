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

@end
