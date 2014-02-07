//
//  DHCalculatorTableViewController.m
//  TellerCalculator
//
//  Created by Derrick Ho on 1/27/14.
//  Copyright (c) 2014 Derrick Ho. All rights reserved.
//

#import "DHCalculatorTableViewController.h"
#import "DHHistoryModel.h"
#import "DHCalculatorBasicViewController.h"
#import "DHTabBarController.h"
#import "HistoryModel.h"

NSString *const kHistoryModel = @"HistoryModel";
NSString *const kHistoryString = @"historyString";
NSString *const kTimeStamp = @"timeStamp";
NSString *const kMyHistoryCell = @"MyHistoryCell";
NSString *const kCacheName = @"Master";

@implementation DHCalculatorTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];
//	[self appendHistory:self object:[[DHHistoryModel alloc] initWithString:@"1+2"]];
//	[self appendHistory:self object:[[DHHistoryModel alloc] initWithString:@"1+2x3"]];
//	[self appendHistory:self object:[[DHHistoryModel alloc] initWithString:@"(1+2)x3"]];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	//[self.tableView reloadData];
}

- (void)appendHistory:(id)sender object:(DHHistoryModel *)object {
	NSManagedObjectContext *context = [[self fetchedResultsController] managedObjectContext];
	NSEntityDescription *entityDesc = [[[self fetchedResultsController] fetchRequest] entity];
	NSManagedObject *newMOC = [NSEntityDescription insertNewObjectForEntityForName:[entityDesc name] inManagedObjectContext:context];
	
	//update properties
	[newMOC setValue:[object historyString] forKey:kHistoryString];
	[newMOC setValue:[NSDate date] forKey:kTimeStamp];
	
	// Save the context.
	NSError *error = nil;
	if (![context save:&error]) {
		// Replace this implementation with code to handle the error appropriately.
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [[[self fetchedResultsController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[self fetchedResultsController] sections][section];
	return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyHistoryCell];
	[self configureCell:cell atIndexPath:indexPath];
	
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		NSManagedObjectContext *context = [[self fetchedResultsController] managedObjectContext];
		[context deleteObject:[[self fetchedResultsController] objectAtIndexPath:indexPath]];
		
		NSError *error = nil;
		if (![context save:&error]) {
			// Replace this implementation with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	// the table should not be re-orderable
	return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	NSLog(@"%@", self.delegate);
	[[self delegate] receiveSelectedTableViewObject:object];
}

#pragma mark - insert new object

//- (void)insertNewObject:(id)sender {
//	
//}

#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)fetchedResultsController {
	if (_fetchedResultsController != nil) {
		return _fetchedResultsController;
	}
	
	NSFetchRequest *fetchRequest = [NSFetchRequest new];
	//Edit entity name as appropriate
	NSEntityDescription *entity = [NSEntityDescription entityForName:kHistoryModel inManagedObjectContext:[self managedObjectContext]];
	[fetchRequest setEntity:entity];
	
	//set batch size to an appropriate number
	[fetchRequest setFetchBatchSize:20]; //batch size of zero is treated as infinite
	
	//Edit sort key as appropriate
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:kTimeStamp ascending:NO];
	[fetchRequest setSortDescriptors:@[sortDescriptor]];
	
	//Edit the section name key path and cache name if appropriate.
	//nill for section name key path means "no sections"
	[self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self managedObjectContext]  sectionNameKeyPath:nil cacheName:kCacheName]];
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Replace this implementation with code to handle the error appropriately.
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	
	return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	switch (type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
		default:
			break;
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	switch (type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeUpdate:
			[self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
		case NSFetchedResultsChangeMove:
			[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		default:
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	cell.textLabel.text = [[object valueForKey:kHistoryString] description];
	cell.detailTextLabel.text = [[object valueForKey:kTimeStamp] description];
}

@end
