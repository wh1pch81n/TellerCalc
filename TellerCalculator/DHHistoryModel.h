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

/**
 initialize the DHHistoryModel with an NSString
 */
- (id)initWithString:(NSString *)str;

/**
 initialize the DHHistoryModel
 */
- (id)init;

/**
 makes a Hard copy of the DHHistoryModel Object
 */
- (DHHistoryModel *)duplicate;

/**
 Modify the History Object
 @param index The Index of the historyString.  Out of bounds will assume end of string
 @param selAmt The amount of selected Text. -1 means single delete. 0 means no selection. 1 and up is the amount of selected text.
 @param text The text that will be inserted at the given index. Nil resolves to an empty string (ie @"")
 */
- (void)spliceHistoryStringAtIndex:(NSUInteger)index selectionAmount:(NSUInteger)selAmt insert:(NSString *)text;

@end
