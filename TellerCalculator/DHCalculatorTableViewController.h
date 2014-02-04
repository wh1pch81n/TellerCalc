//
//  DHCalculatorTableViewController.h
//  TellerCalculator
//
//  Created by Derrick Ho on 1/27/14.
//  Copyright (c) 2014 Derrick Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHHistoryModel;

@interface DHCalculatorTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *history;
@property (weak) id delegate;

/**
 appends a hardcopy of the DHHistoryModel to the table.
 @param sender The sender of this function
 @param object the DHHistoryModel to be appended
 */
- (void)appendHistory:(id)sender object:(DHHistoryModel *)object;

@end

@protocol DHCalculatorTableViewControllerDelegate <NSObject>

- (void)receiveSelectedTableViewObject:(id)object;

@end
