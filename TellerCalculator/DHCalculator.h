//
//  DHCalculator.h
//  TellerCalculator
//
//  Created by Derrick Ho on 5/17/13.
//  Copyright (c) 2013 Derrick Ho. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString* formatNumber( NSString* s);
//void error(NSString * I) ;

@interface DHCalculator: NSObject{
	NSString* _origExpression;
	NSInteger _tokenLine;
	NSArray* _tokenArr;
	NSInteger _parserLine;
	NSArray* _parserArr;
	NSInteger _tabDepth;
	NSMutableArray* _compiledTermArr;
}

-(NSString*) CalculatedAnswerAsString:(NSString*) expression;
-(float) CalculatedAnswerAsFloat:(NSString*) expression;
-(BOOL) isExpressionBegin:(NSString*) line;
-(BOOL) isExpressionEnd:(NSString*) line;
-(BOOL) isExpressionListBegin:(NSString*) line;
-(BOOL) isExpressionListEnd:(NSString*) line;
-(bool) isFunctionBegin:(NSString*) line;
-(bool) isFunctionEnd:(NSString *) line;
-(BOOL) isParenthesesBegin:(NSString*) line;
-(BOOL) isParenthesesEnd:(NSString*) line;
-(BOOL) isTermBegin:(NSString*) line;
-(BOOL) isTermEnd:(NSString*) line;
-(void) handleExpression;
-(NSArray*) ParserToEncapsulateExpression;
-(void) solveExpressionList;
-(void) solveExpression;
-(bool) precedenceOfThis:(NSString*) lhs isGreaterThan:(NSString*) rhs;
-(bool) precedenceOfThis:(NSString*) lhs isLessThan:(NSString*) rhs;
-(bool) precedenceOfThis:(NSString*) lhs isEqualTo:(NSString*) rhs;
-(bool) PerformMathFunct:(NSString*) mathFnName;
-(NSString*) getTopOfArrAndPop:(NSMutableArray*) arr;
-(void) solveParentheses;
-(void) solveTerminal;
-(void) solveFunction;
-(NSString*) extractItemFromString:(NSString*) line;
-(void) error:(NSString *)I;
@end