//
//  DHCalculatorBasicViewController.m
//  TellerCalculator
//
//  Created by Derrick Ho on 1/27/14.
//  Copyright (c) 2014 Derrick Ho. All rights reserved.
//

#import "DHCalculatorBasicViewController.h"
#import "DHTabBarController.h"
#import "DHHistoryModel.h"
//#import "UITextField+DHTextField.h"

@interface DHCalculatorBasicViewController ()

@property (strong, atomic)UIView *customKeyboardView;

@property (weak, atomic)DHTabBarController *TBC;

@end

@implementation DHCalculatorBasicViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.TBC = (DHTabBarController *)self.tabBarController;
	self.displayTextField.inputView = [self initializeCustomKeyboardView];
	
	//TODO add KVO here so that when the tabbar's value changes it can change the display's text right away.  For now update the display by hand in the viewdidAppear
	[self.TBC.historyModel addObserver:self forKeyPath:@"historyString" options:NSKeyValueObservingOptionNew context:nil];

}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.displayTextField becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated {
	[self.displayTextField resignFirstResponder];
	[super viewWillDisappear:animated];
}

- (UIView *)initializeCustomKeyboardView {
	self.customKeyboardView = [[[NSBundle mainBundle] loadNibNamed:@"DHBasicKeyboardView" owner:self options:nil] lastObject];
	return self.customKeyboardView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"historyString"]) {
		NSString *HS = [(DHHistoryModel *)object historyString];
		[self.displayTextField setText:HS];
	}
}

- (IBAction)tappedBackspace:(id)sender {
//	NSLog(@"%@", self.displayTextField.selectedTextRange);
//	NSLog(@"%d %d", self.displayTextField.selectedRange.location, self.displayTextField.selectedRange.length);
	[self.TBC modifyHistoryModelWithKey:@"backspace" atRange:NSMakeRange(self.displayTextField.text.length-1, 1)];
}

@end