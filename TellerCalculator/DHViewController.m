//
//  DHViewController.m
//  TellerCalculator
//
//  Created by Derrick Ho on 5/17/13.
//  Copyright (c) 2013 Derrick Ho. All rights reserved.
//

#import "DHViewController.h"
#import "DHCalculator.h"
@interface DHViewController ()

@end

@implementation DHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[[self TextField] becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
	[self setTextField:nil];
	[super viewDidUnload];
}
-(void)ValidateThenPerformSelector:(SEL) select{ //TODO: port to new home
	NSString* text = [[self TextField]text];
	if ( [text isEqualToString:@""]) {
		return;
	}else if( [[text substringFromIndex:text.length-1] isEqualToString:@"%"] ||
			 ([text characterAtIndex:text.length-1] >= '0' && [text characterAtIndex:text.length-1] <= '9')
			  ||
			( [text characterAtIndex:text.length-1] == ')')
			 ){
		
		#pragma clang diagnostic push
		#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		[self performSelector:select];
		#pragma clang diagnostic pop
	}

}
-(void) doSolveEquation{
	//temporaily clear text
	NSString* answer= @"";
	NSString* text = self.TextField.text;
	text =[text stringByReplacingOccurrencesOfString:@"%" withString:@"*0.01"];
	text =[text stringByReplacingOccurrencesOfString:@"x" withString:@"*"];
	text =[text stringByReplacingOccurrencesOfString:@"÷" withString:@"/"];
	answer = [[DHCalculator new]
			  CalculatedAnswerAsString:text];
	if (answer){
		answer = formatNumber(answer);
		[[self TextField] setText:answer];
	}else{
		[[[UIAlertView alloc] initWithTitle:@"invalid equation" message:@"This equation can not be resolved" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil]
		 show];
	}
}
-(void) doPushMultiply{
	[[self TextField]setText:[self.TextField.text stringByAppendingString:@"x"]];
}
-(void) doPushDiv{
	[[self TextField]setText:[self.TextField.text stringByAppendingString:@"÷"]];
}
-(void) doPushPercent{
	[[self TextField]setText:[self.TextField.text stringByAppendingString:@"%"]];
}
-(void) doPushAdd{
	[[self TextField]setText:[self.TextField.text stringByAppendingString:@"+"]];
}
-(void) doPushSubtract{
	[[self TextField]setText:[self.TextField.text stringByAppendingString:@"-"]];
}
- (IBAction)clearTextField:(id)sender {
	[[self TextField] setText:@""];
}

- (IBAction)SolveEquation:(id)sender {//TODO: port this to new home
	[self ValidateThenPerformSelector:@selector(doSolveEquation)];
}
- (IBAction)pushMultiply:(id)sender{
	[self ValidateThenPerformSelector:@selector(doPushMultiply)];
}
- (IBAction)pushDiv:(id)sender{
	[self ValidateThenPerformSelector:@selector(doPushDiv)];
}
- (IBAction)pushPercent:(id)sender{
	[self ValidateThenPerformSelector:@selector(doPushPercent)];}
- (IBAction)pushAdd:(id)sender{
	[self ValidateThenPerformSelector:@selector(doPushAdd)];
}
- (IBAction)pushSubtract:(id)sender{
	[self ValidateThenPerformSelector:@selector(doPushSubtract)];
}

- (IBAction)pushNumPad:(id)sender {
	[[self TextField]setText:
	 [self.TextField.text stringByAppendingFormat:@"%d",[sender tag]]];
}

- (IBAction)pushBackSpace:(id)sender {
	if ([self.TextField.text isEqualToString:@""]) {
		return;
	}else{
		[[self TextField]setText:
		 [self.TextField.text substringToIndex:self.TextField.text.length -1]];
	}
}

- (IBAction)pushPeriod:(id)sender {
	//doesn't prevent 0.0.0 from being entered.  Doesn't appear to cause problems
	//but it is worth noting at least
	NSString* text = [[self TextField]text];
	if ( [text isEqualToString:@""] ||
		[text characterAtIndex:text.length-1] == 'x'||
		[[text substringWithRange:NSMakeRange(text.length-1, 1)]isEqualToString:@"÷"]||
		[text characterAtIndex:text.length-1] == '+'||
		[text characterAtIndex:text.length-1] == '-') {
		[self.TextField setText:[text stringByAppendingString:@"0."]];
	}else if([text characterAtIndex:text.length-1] >= '0' &&
			  [text characterAtIndex:text.length-1] <= '9'){
		[self.TextField setText:[text stringByAppendingString:@"."]];
	}
}

- (IBAction)Parentheses:(id)sender {
	[[self TextField] setText:
	 [self.TextField.text stringByAppendingString:
	  [sender restorationIdentifier]]];
}

@end
