//
//  DHViewController.h
//  TellerCalculator
//
//  Created by Derrick Ho on 5/17/13.
//  Copyright (c) 2013 Derrick Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *TextField;
- (IBAction)clearTextField:(id)sender;
- (IBAction)SolveEquation:(id)sender;
- (IBAction)pushMultiply:(id)sender;
- (IBAction)pushDiv:(id)sender;
- (IBAction)pushPercent:(id)sender;
- (IBAction)pushAdd:(id)sender;
- (IBAction)pushSubtract:(id)sender;
- (IBAction)pushNumPad:(id)sender;
- (IBAction)pushBackSpace:(id)sender;
- (IBAction)pushPeriod:(id)sender;
- (IBAction)Parentheses:(id)sender;


@end
