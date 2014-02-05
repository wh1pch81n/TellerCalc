//
//  DHCalculatorTableViewCoreData.m
//  TellerCalculator
//
//  Created by Derrick Ho on 2/4/14.
//  Copyright (c) 2014 Derrick Ho. All rights reserved.
//

#import "DHCalculatorTableViewCoreData.h"
#import <CoreData/CoreData.h>

NSString *const kDHHistoryModel = @"DHHistoryModel";
NSString *const kSqlite = @"sqlite";
NSString *const kMomd = @"momd";

@implementation DHCalculatorTableViewCoreData

@synthesize moc = _moc;
@synthesize mom = _mom;
@synthesize psc = _psc;

#pragma mark - Applications's documents directory

/**
 Returns the URL to the application's documents directory
 */
- (NSURL *)applicationDocumentsDirectory {
	return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
}

#pragma mark - Core Data Stack

/**
 Returns the managed object context for the TableViewController.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the tablevViewController
 */
- (NSManagedObjectContext *)managedObjectContext {
	if (_moc) {
		return self.managedObjectContext;
	}
	
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (coordinator) {
		_moc = [[NSManagedObjectContext alloc] init];
		_moc.persistentStoreCoordinator = coordinator;
	}
	
	return _moc;
}

/**
 Returns the managed object model for the tableViewController.
 If the model doesn't already exist, it is created
 */
- (NSManagedObjectModel *)managedObjectModel {
	if (_mom) {
		return _mom;
	}
	
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kDHHistoryModel withExtension:kMomd];
	_mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	
	return _mom;
}

/**
 Returns the persistent store coordinator for the TableViewController.
 If the coordinator doesn't already exist, it is created and the store is added to it
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	if (_psc) {
		return _psc;
	}
	
	NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", kDHHistoryModel, kSqlite]];
	
	NSError *error = nil;
	_psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.mom];
	
	if (![_psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible;
		 * The schema for the persistent store is incompatible with current managed object model.
		 Check the error message to determine what the actual problem was.
		 
		 
		 If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
		 
		 If you encounter schema incompatibility errors during development, you can reduce their frequency by:
		 * Simply deleting the existing store:
		 [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
		 
		 * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
		 @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
		 
		 Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
		 
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	
	return _psc;
}

#pragma mark - Save Context

- (void)saveContext {
	NSError *error = nil;
	if (_moc) {
		if (_moc.hasChanges && ![_moc save:&error]) {
			// Replace this implementation with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}
}

@end
