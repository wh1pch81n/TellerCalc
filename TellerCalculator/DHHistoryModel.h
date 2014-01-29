//
//  DHHistoryModel.h
//  TellerCalculator
//
//  Created by Derrick Ho on 1/27/14.
//  Copyright (c) 2014 Derrick Ho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHHistoryModel : NSObject

@property (strong, atomic) NSString *historyString;

- (id)initWithString:(NSString *)str;

- (id)init;

@end
