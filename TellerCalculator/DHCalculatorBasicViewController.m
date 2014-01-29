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
	[self.TBC addObserver:self forKeyPath:@"historyModel" options:NSKeyValueObservingOptionNew context:nil];

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
	if ([keyPath isEqualToString:@"historyModel"]) {
		DHHistoryModel *HM = (DHHistoryModel *)[object valueForKey:@"historyModel"];
		[self.displayTextField setText:HM.historyString];
	}
}

- (IBAction)tappedBackspace:(id)sender {
	[self.TBC modifyHistoryModelWithKey:@"backspace"];
}

@end
