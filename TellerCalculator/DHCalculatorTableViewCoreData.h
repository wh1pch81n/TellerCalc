//
//  DHCalculatorTableViewCoreData.h
//  TellerCalculator
//
//  Created by Derrick Ho on 2/4/14.
//  Copyright (c) 2014 Derrick Ho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHCalculatorTableViewCoreData : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *moc;
@property (readonly, strong, nonatomic) NSManagedObjectModel *mom;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *psc;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirector;
- (NSManagedObjectContext *)managedObjectContext;
- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

@end
