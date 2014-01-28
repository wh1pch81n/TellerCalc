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

@implementation DHCalculatorTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self appendHistory:self object:[[DHHistoryModel alloc] initWithString:@"1+2"]];
	[self appendHistory:self object:[[DHHistoryModel alloc] initWithString:@"1+2x3"]];
	[self appendHistory:self object:[[DHHistoryModel alloc] initWithString:@"(1+2)x3"]];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)appendHistory:(id)sender object:(DHHistoryModel *)object {
	if (!self.history) {
		self.history = [[NSMutableArray alloc] init];
	}
	
	[self.history insertObject:object atIndex:0];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.history.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyHistoryCell"];
	DHHistoryModel *h = [self.history objectAtIndex:indexPath.row];
	cell.textLabel.text = h.historyString;
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		[self.history removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DHHistoryModel *chosenModel = self.history[indexPath.row];
	DHTabBarController *tabBarController = (DHTabBarController *)self.tabBarController;
	[tabBarController setBasicCalculatorDisplay:chosenModel.historyString];
	[tabBarController segueToBasicCalculatorViewController];
}

- (IBAction)tappedHistoryCell:(id)sender {
	
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
}





@end
