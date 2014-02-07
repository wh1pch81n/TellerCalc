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

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Applications's documents directory

/**
 Returns the URL to the application's documents directory
 */
- (NSURL *)applicationDocumentsDirectory {
	NSFileManager *defaultManager = [NSFileManager defaultManager];
	NSLog(@"%@", defaultManager);
	NSArray *urls = [defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
	NSLog(@"%@", urls);
	NSURL *url = [urls lastObject];
	NSLog(@"%@", url);
	return url;
}

#pragma mark - Core Data Stack

/**
 Returns the managed object context for the TableViewController.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the tablevViewController
 */
- (NSManagedObjectContext *)managedObjectContext {
	if (_managedObjectContext != nil) {
		return _managedObjectContext;
	}
	
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (coordinator != nil) {
		_managedObjectContext = [NSManagedObjectContext new];
		[_managedObjectContext setPersistentStoreCoordinator:coordinator];
	}
	
	return _managedObjectContext;
}

/**
 Returns the managed object model for the tableViewController.
 If the model doesn't already exist, it is created
 */
- (NSManagedObjectModel *)managedObjectModel {
	if (_managedObjectModel != nil) {
		return _managedObjectModel;
	}
	
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kDHHistoryModel withExtension:kMomd];
	_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	
	return _managedObjectModel;
}

/**
 Returns the persistent store coordinator for the TableViewController.
 If the coordinator doesn't already exist, it is created and the store is added to it
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	if (_persistentStoreCoordinator != nil) {
		return _persistentStoreCoordinator;
	}
	
	NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", kDHHistoryModel, kSqlite]];
	NSLog(@"%@", storeURL);
	NSError *error = nil;
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	
	if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
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
	
	return _persistentStoreCoordinator;
}

#pragma mark - Save Context

- (void)saveContext {
	NSError *error = nil;
	if (self.managedObjectContext != nil) {
		if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
			// Replace this implementation with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}
}

@end
