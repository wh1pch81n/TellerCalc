//
//  HistoryModel.h
//  TellerCalculator
//
//  Created by Derrick Ho on 2/3/14.
//  Copyright (c) 2014 Derrick Ho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HistoryModel : NSManagedObject

@property (nonatomic, retain) NSString * historyString;

@end
