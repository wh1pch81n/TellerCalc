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
#import "DHButton.h"
//#import "UITextField+DHTextField.h"

@interface DHCalculatorBasicViewController ()

@property (weak, nonatomic) IBOutlet UITextField *displayTextField;
@property (strong, atomic) UIView *customKeyboardView;
@property (nonatomic, copy) void (^observerBlock)(NSString *keyPath, id object, UITextField *displayTextField);

@end

@implementation DHCalculatorBasicViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.displayTextField.inputView = [self initializeCustomKeyboardView];
	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.displayTextField becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated {
	[self.displayTextField resignFirstResponder];
	[super viewWillDisappear:animated];
}

- (void)displayTextShallObserve:(id)object forKeyPath:(NSString *)keypath observedChange:(void (^)(NSString *, id, UITextField *))observedChange{
	[object addObserver:self forKeyPath:keypath options:NSKeyValueObservingOptionNew context:Nil];
	[self setObserverBlock:observedChange];
}

- (UIView *)initializeCustomKeyboardView {
	self.customKeyboardView = [[[NSBundle mainBundle] loadNibNamed:@"DHBasicKeyboardView" owner:self options:nil] lastObject];
	return self.customKeyboardView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (self.observerBlock) {
		self.observerBlock(keyPath, object, self.displayTextField);
	}
}

- (IBAction)tappedButton:(id)sender {
	//NSLog(@"%@", [sender valueForKey:@"keyCode"]);
	//	NSLog(@"%@", self.displayTextField.selectedTextRange);
	//	NSLog(@"%d %d", self.displayTextField.selectedRange.location, self.displayTextField.selectedRange.length);
	
	//TODO:figure out how to get the cursor position and the selection amount so you can make a more accurate NSRange
	
	DHButton *key = (DHButton *)sender;
	[self.delegate modifyHistoryModelWithKey:key.keyCode atRange:NSMakeRange(self.displayTextField.text.length, 0)];
	
	//TODO: might have to reposition the cursor at this point.  It might default to the end of the string.
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
	if (textField == self.displayTextField) {
		[self.delegate modifyHistoryModelWithKey:kBackspace atRange:NSMakeRange(0, self.displayTextField.text.length)];
	}
	return NO;
}

@end