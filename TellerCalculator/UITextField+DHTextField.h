//
//  UITextField+DHTextField.h
//  TellerCalculator
//
//  Created by Derrick Ho on 1/29/14.
//  Copyright (c) 2014 Derrick Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (DHTextField)

- (void)setSelectedRange:(NSRange)selectedRange;

- (NSRange)selectedRange;

@end
