//
//  DHCalculatorBasicViewController.h
//  TellerCalculator
//
//  Created by Derrick Ho on 1/27/14.
//  Copyright (c) 2014 Derrick Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHCalculatorBasicViewController : UIViewController <UITextFieldDelegate>


@property (weak)id delegate;

- (void)displayTextShallObserve:(id)object forKeyPath:(NSString *)keypath observedChange:(void(^)(NSString *keyPath, id object, UITextField *displayTextField))observedChange;

@end

@protocol DHCalculatorBasicViewDelegate <NSObject>

@optional

/**
 This method is called when a the DHCalculatorBasicViewController has a button event.  Implement this to do something specific with the information.
 @param key the name of the key that was pressed
 @param range The location property marks position of the caret (0 being before the first character and str.length and greater being after the last character). The length property counts how many characters are highlighted.
 */
- (void)modifyHistoryModelWithKey:(NSString *)key atRange:(NSRange)range;

@end