//
//  DHCalculator.m
//  TellerCalculator
//
//  Created by Derrick Ho on 5/17/13.
//  Copyright (c) 2013 Derrick Ho. All rights reserved.
//

#import "DHCalculator.h"
#import "DHPair.h"
#import <Foundation/Foundation.h>

#define DEBUGGING false
#define elif else if
#define TAGSYMBOL(I) [self stringWithTag:@"symbol" originalString: (I)]
#define TAGINTEGER(I) [self stringWithTag:@"integerConstant" originalString: (I)]
#define TAGFLOAT(I) [self stringWithTag:@"floatConstant" originalString: (I)]
#define TAGKEYWORD(I) [self stringWithTag:@"keyword" originalString: (I)]
#define TAGIDENTIFIER(I) [self stringWithTag:@"identifier" originalString: (I)]

#define TAG_FUNCTION_OPEN @"<callFunction>"
#define TAG_FUNCTION_CLOSE @"</callFunction>"
#define TAG_EXPRESSION_OPEN  @"<expression>"
#define TAG_EXPRESSION_CLOSE  @"</expression>"
#define TAG_EXPRESSION_LIST_OPEN  @"<expressionList>"
#define TAG_EXPRESSION_LIST_CLOSE  @"</expressionList>"
#define TAG_SYMBOL_OPEN  @"<symbol>"
#define TAG_SYMBOL_CLOSE  @"</symbol>"
#define TAG_TERM_OPEN  @"<term>"
#define TAG_TERM_CLOSE  @"</term>"
#define TAG_INTEGER_OPEN  @"<integerConstant>"
#define TAG_INTEGER_CLOSE  @"</integerConstant>"
#define TAG_FLOAT_OPEN  @"<floatConstant>"
#define TAG_FLOAT_CLOSE  @"</floatConstant>"
#define TAG_IDENTIFIER_OPEN @"<identifier>"
#define TAG_IDENTIFIER_CLOSE @"</identifier>"

#define ITEM_PARENTHESES_OPEN  @" ( "
#define ITEM_PARENTHESES_CLOSE  @" ) "
#define ITEM_PLUS  @" + "
#define ITEM_MINUS  @" - "
#define ITEM_MULT  @" * "
#define ITEM_DIV  @" / "
#define ITEM_EXPONENT  @" ^ "
#define ITEM_COMMA @" , "

#define dMakeFnOpPair( I,J) [pair_fn_op MakeFnOpPair:I :J ]

static NSDictionary* _FnOp_dict = nil;

@implementation DHCalculator
-(id) init{
	self = [super init];
	if (self ) {
		if(_FnOp_dict == nil){
			_FnOp_dict =	@{
				   @"neg" :dMakeFnOpPair( FN_NEG, OP_UNARY),
				   @"^" :dMakeFnOpPair( FN_EXPONENT, OP_EXPONENT),
				   @"*" :dMakeFnOpPair( FN_MULT, OP_MULT) ,
				   @"/" :dMakeFnOpPair( FN_DIV, OP_DIV),
				   @"+" :dMakeFnOpPair( FN_ADD, OP_ADD) ,
				   @"-" :dMakeFnOpPair( FN_SUB, OP_SUB)
				   };
			
		}
	}
	return self;
}

-(NSString*) stringWithTag: (const NSString*) tag originalString:(const NSString*) str{
	return [NSString stringWithFormat:@"<%@> %@ </%@>", tag, str, tag];
}
-(BOOL) isCharacter:(NSString*)c{
	char letter = [c UTF8String][0];
	letter &= 0x20;//lowercase letter
	if ( letter >= 'a' && letter <= 'z') {
		return YES;
	}
	return NO;
}
-(BOOL) isNumber:(NSString*)c{
	return ( [c integerValue] ||
			[[c substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]||
			[[c substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"."])? YES : NO;
}
-(BOOL) isSymbol:(NSString*)c{
	NSString * singleChar = [c substringWithRange:NSMakeRange(0,1)];
	if( [singleChar isEqualToString:@"("] ||
	   [singleChar isEqualToString:@")"] ||
	   [singleChar isEqualToString:@"-"] ||
	   [singleChar isEqualToString:@"^"] ||
	   [singleChar isEqualToString:@"*"] ||
	   [singleChar isEqualToString:@"/"] ||
	   [singleChar isEqualToString:@"+"]
	   ){
		return YES;
	}
	return NO;
}
-(NSString*) stringByRemovingAllWhitespaceFromString: (NSString*)str{
	str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	return str;
}
-(NSArray*) TokenizeString{
	_origExpression = [self stringByRemovingAllWhitespaceFromString:_origExpression];
	_tokenArr = [NSArray new];
	BOOL finished = NO;
	NSInteger right = 0;
	NSString * character = @"";
	//3 tokens of importance: symbols, integerConstants, floatConstant
	
	enum tokenStates {
		eINIT, eANALYSE_CHAR, eSYMBOL, eINTEGER_CONSTANT,
		eFLOAT_CONSTANT, eEND
	};
	int state = eINIT;
	NSInteger cursor=0;
	while (!finished) {
		switch (state) {
			case eINIT:{
				cursor = 0;
				state = eANALYSE_CHAR;
			}break;
			case eANALYSE_CHAR:{
				if (cursor >= _origExpression.length) {
					state = eEND;
				}else{
					character = [_origExpression substringWithRange: NSMakeRange(cursor, 1)];
					if ( [self isCharacter:character]) {
						character = @"Identifier handeling not yet implemented\n";
						state = -1;
					}else if( [self isNumber:character]){
						state = eINTEGER_CONSTANT;
					}else if( [self isSymbol:character]){
						state = eSYMBOL;
					}else{
						state = -1;//goes to default state;
					}
				}
			}break;
			case eSYMBOL:{
				NSString * tagged = TAGSYMBOL(character);
				_tokenArr = [_tokenArr arrayByAddingObject: tagged];
				++cursor;
				state = eANALYSE_CHAR;
			}break;
			case eINTEGER_CONSTANT:{
				
				right = cursor;
				//move cursor until non symbol is reached
				while ( (right) < _origExpression.length )	{
					if ([self isNumber:[_origExpression substringWithRange: NSMakeRange(right, 1)]]) {
						++right;
						continue;
					}
					break;
				}
				if( right >= _origExpression.length){
					NSString* tagged = TAGINTEGER([_origExpression substringFromIndex:cursor]);
					_tokenArr = [_tokenArr arrayByAddingObject:tagged];
					cursor = right;
					state = eANALYSE_CHAR;
				}else if( [[_origExpression substringWithRange:NSMakeRange(right, 1)]
						   isEqualToString:@"."]){
					++right;
					state = eFLOAT_CONSTANT;
				}else{
					NSString* tagged = TAGINTEGER([_origExpression substringWithRange: NSMakeRange(cursor, right-cursor)]);
					_tokenArr = [_tokenArr arrayByAddingObject:tagged];
					cursor = right;
					state = eANALYSE_CHAR;
				}
			}break;
			case eFLOAT_CONSTANT:{
				while ( (right) < _origExpression.length )	{
					if ([self isNumber:[_origExpression substringWithRange: NSMakeRange(right, 1)]]) {
						++right;
						continue;
					}
					break;
				}
				NSString* substr = [_origExpression substringWithRange: NSMakeRange(cursor, right-cursor)];
				NSString* tagged = TAGFLOAT(substr);
				
				_tokenArr = [_tokenArr arrayByAddingObject:tagged];
				cursor = right;
				state = eANALYSE_CHAR;
			}break;
			case eEND:{
				finished = YES;
			}break;
			default:{//error state then exit
				printf("\nUnknownToken: %s\n", [character UTF8String]);
				state = eEND;
			}break;
		}
	}
	return _tokenArr;
}
-(void) appendParserArrMSG_w_tabs:(NSString*) msg{
	NSString * s =[NSString new];
	NSInteger i;
	for (i = 0; i < _tabDepth; ++i) {
		s = [s stringByAppendingString:@"\t"];
	}
	s = [s stringByAppendingString:msg];
	
	_parserArr = [_parserArr arrayByAddingObject:s];
	
}
-(BOOL) containedInString:(NSString*) source
					isTag:(NSString*) tag
			isMiddleValue:(NSString*) item{
	if([source rangeOfString:tag].location == NSNotFound ||
	   [source rangeOfString:item].location == NSNotFound){
		return NO;
	}
	return YES;
}
-(BOOL) containedInString:(NSString*) source isThisValue:(NSString*) val{
	return ( [source rangeOfString:val].location == NSNotFound)? NO: YES;
}
-(BOOL) isOperator:(NSString*) currline{
	if ([currline rangeOfString:ITEM_MULT].length != NSNotFound ||
		[currline rangeOfString:ITEM_DIV].length != NSNotFound ||
		[currline rangeOfString:ITEM_PLUS].length != NSNotFound ||
		[currline rangeOfString:ITEM_MINUS].length != NSNotFound ) {
		return YES;
	}
	return NO;
}
-(void) handleTerminal{
	[self appendParserArrMSG_w_tabs:TAG_TERM_OPEN];
	_tabDepth++;
	
	//if(self.isAJackFunctionCall()): 	#handle function
	//self.encapsulateAsFunctionCall()
	if([self containedInString:[_tokenArr objectAtIndex:_tokenLine]
						 isTag:TAG_SYMBOL_OPEN
				 isMiddleValue:ITEM_PARENTHESES_OPEN]
	   )	{	//handle a nested expression
		[self appendParserArrMSG_w_tabs:[_tokenArr objectAtIndex:_tokenLine++]];
		[self handleExpression];
		[self appendParserArrMSG_w_tabs:[_tokenArr objectAtIndex:_tokenLine++]];
	}
	else if( [self containedInString:[_tokenArr objectAtIndex:_tokenLine]
							   isTag:TAG_SYMBOL_OPEN
					   isMiddleValue:ITEM_MINUS]
			){ //handle unary
		//		[self appendParserArrMSG_w_tabs:[_tokenArr objectAtIndex:_tokenLine++]];
		//[self appendParserArrMSG_w_tabs: TAGSYMBOL(@"~")];
		//replace negative with a neg() function
		[self appendParserArrMSG_w_tabs:TAG_FUNCTION_OPEN];
		_tabDepth++;
		[self appendParserArrMSG_w_tabs:TAGIDENTIFIER(@"neg")];
		_tokenLine++;
		[self appendParserArrMSG_w_tabs:TAGSYMBOL(@"(")];
		[self appendParserArrMSG_w_tabs:TAG_EXPRESSION_LIST_OPEN];
		_tabDepth++;
		//[self handleTerminal];
		[self handleExpression];
		_tabDepth--;
		[self appendParserArrMSG_w_tabs:TAG_EXPRESSION_LIST_CLOSE];
		[self appendParserArrMSG_w_tabs:TAGSYMBOL(@")")];
		_tabDepth--;
		[self appendParserArrMSG_w_tabs:TAG_FUNCTION_CLOSE];
		
	}
	//	elif(
	//		 self.currLineHas("<identifier>", "</identifier>")){//	#handle variables
	//		self.currLine = tag_as_used_variable(self.SymTableStack, self.getCurrLine())
	//		self.printCurrTokenAndIncrement()
	//	}
	else{//#handle everything else
		[self appendParserArrMSG_w_tabs:[_tokenArr objectAtIndex:_tokenLine++]];
	}
	_tabDepth--;
	[self appendParserArrMSG_w_tabs:TAG_TERM_CLOSE];
	
}
-(void) handleExpression{
	enum expressionStates {eSTART_EXP, eUNARY_SYMBOL, eIDENTIFIER,
		eOPERATOR_SYMBOL, eEND, ePARENTHESES
	}state;
	BOOL isFinished = NO;
	state = eSTART_EXP;
	while (!isFinished) {
		switch(state){
			case eSTART_EXP:{
				[self appendParserArrMSG_w_tabs: TAG_EXPRESSION_OPEN];
				_tabDepth++;
				NSString* currLine = [_tokenArr objectAtIndex:_tokenLine];
				if ([self containedInString:currLine isTag:TAG_SYMBOL_OPEN isMiddleValue:ITEM_MINUS]) {
					state = eUNARY_SYMBOL;
				}elif([self containedInString:currLine isThisValue:TAG_INTEGER_OPEN] ||
					  [self containedInString:currLine isThisValue:TAG_FLOAT_OPEN] ){
					state = eIDENTIFIER;
				}elif( [self containedInString:currLine isTag:TAG_SYMBOL_OPEN isMiddleValue:ITEM_PARENTHESES_OPEN]){
					state = ePARENTHESES;
				}else{
					[self error:@"invalid expression"];
					return;
				}
			}break;
			case eUNARY_SYMBOL:{
				if ( [self containedInString:[_tokenArr objectAtIndex:_tokenLine]
									   isTag:TAG_SYMBOL_OPEN
							   isMiddleValue:ITEM_MINUS]) {
					//					[self handleTerminal];
					state = ePARENTHESES;
				}else{
					[self error:(@"expected unary \"-\"")];
					return;
				}
			}break;
			case eIDENTIFIER:{
				state = ePARENTHESES;
			}break;
			case eOPERATOR_SYMBOL:{
				[self appendParserArrMSG_w_tabs:[_tokenArr objectAtIndex:_tokenLine++]];
				if( [self containedInString:[_tokenArr objectAtIndex:_tokenLine]
									  isTag:TAG_SYMBOL_OPEN
							  isMiddleValue:ITEM_MINUS]){
					state = eUNARY_SYMBOL;
				}else if( [self containedInString:[_tokenArr objectAtIndex:_tokenLine]
									  isThisValue:TAG_INTEGER_OPEN] ||
						 [self containedInString:[_tokenArr objectAtIndex:_tokenLine]
									 isThisValue:TAG_FLOAT_OPEN]){
							 state = eIDENTIFIER;
						 }else if( [self containedInString:[_tokenArr objectAtIndex:_tokenLine]
													 isTag:TAG_SYMBOL_OPEN
											 isMiddleValue:ITEM_PARENTHESES_OPEN]){
							 state =ePARENTHESES;
						 }else{
							 [self error:(@"expected identifier or unary operators after an operand")];
							 return;
						 }
			}break;
			case ePARENTHESES:{
				[self handleTerminal];
				if (_tokenLine >= _tokenArr.count ||
					[ self containedInString:[_tokenArr objectAtIndex:_tokenLine]
									   isTag:TAG_SYMBOL_OPEN
							   isMiddleValue:ITEM_PARENTHESES_CLOSE]) {
						state = eEND;
					}elif([self isOperator:[_tokenArr objectAtIndex:_tokenLine]]){
						state = eOPERATOR_SYMBOL;
					}else{
						[self error:([NSString stringWithFormat:@"expected operator between identifiers [%@]", [_tokenArr objectAtIndex:_tokenLine] ])];
						return;
					}
			}break;
			case eEND:{
				_tabDepth--;
				[self appendParserArrMSG_w_tabs:TAG_EXPRESSION_CLOSE];
				isFinished = YES;
			}break;
			default:
				state = eEND;
		}
	}
	
	if (_tokenArr == nil ){ return;}
}

-(NSArray*) ParserToEncapsulateExpression{
	_tabDepth = 0;
	_parserLine = 0;
	_parserArr = [NSArray new];
	[self handleExpression];
	return _parserArr;
}
//-(float) compileExpression{
//	_compiledTermArr = [NSMutableArray new];
////	_compiledOpArr = [NSMutableArray new];
//	_parserLine = 0;
//	return [[_compiledTermArr objectAtIndex:0] floatValue];
//}
-(void) solveExpressionList{
	if([self isExpressionListBegin:[_parserArr objectAtIndex:_parserLine]]){
		_parserLine++;
		while (! [self isExpressionListEnd:[_parserArr objectAtIndex:_parserLine]]) {
			if ([self isExpressionBegin:[_parserArr objectAtIndex:_parserLine]]) {
				[self solveExpression];
			}else if([ self containedInString:[_parserArr objectAtIndex:_parserLine]
										isTag:TAG_SYMBOL_OPEN
								isMiddleValue:ITEM_COMMA]){
				// usually I'd use this area to help count eh number of arguments
				// but the functions of this project only require a single argument
				// therefore this part will do nothing except look pretty
			}else{
				[self error:(@"Unknown tag in expressionList")];
			}
			if (_parserArr == nil ){ return;}
			_parserLine++;
		}
	}else{
		[self error:(@"expected expression list") ];
	}
}
-(void) solveExpression{ //handles operator precidence.controls  _compiledOpArr
	if( [self isExpressionBegin:[_parserArr objectAtIndex:_parserLine]]){
		_parserLine++;
		NSMutableArray* _compiledOpArr = [NSMutableArray new];
		
		for(; ![self isExpressionEnd:[_parserArr objectAtIndex:_parserLine]]; _parserLine++){
			if( [self isTermBegin:[_parserArr objectAtIndex:_parserLine]]){
				[self solveTerminal];  //should be on </term>
			}else if([self containedInString:[_parserArr objectAtIndex:_parserLine]
								 isThisValue:TAG_SYMBOL_OPEN]){
				//todo: figure out how to deal with the two arrays.
				NSString*  extractedOperator = [self extractItemFromString:[_parserArr objectAtIndex:_parserLine]];
				if(_compiledOpArr.count > 0){
					if( ![self precedenceOfThis:[_compiledOpArr lastObject]
									 isLessThan:extractedOperator]
					   ){ //top >= new
						[self PerformMathFunct:[_compiledOpArr lastObject]];
						[_compiledOpArr removeLastObject];
					}
				}
				[_compiledOpArr addObject:extractedOperator];
			}
		}
		/*after expression finishes I should perform if the _compileOpArr is not empty
		 i.e. is the expression was (1+2) the above loop will place 1,2 on the termarr
		 and  + on the op arr.  we must perform it to get 3 on the termarr
		 */
		while ( _compiledOpArr.count){//i.e. in case we get expression of (9)
			[self PerformMathFunct:[_compiledOpArr lastObject]];
			[_compiledOpArr removeLastObject];
		}
	}else{
		[self error:(@"expected expression 0")];
	}
}
-(bool) precedenceOfThis:(NSString*) lhs isGreaterThan:(NSString*) rhs{
	if([[ _FnOp_dict objectForKey:lhs] operator_Pre] >
	   [[ _FnOp_dict objectForKey:rhs] operator_Pre]){
		return YES;
	}
	return  NO;
}
-(bool) precedenceOfThis:(NSString*) lhs isLessThan:(NSString*) rhs{
	if([[ _FnOp_dict objectForKey:lhs] operator_Pre] <
	   [[ _FnOp_dict objectForKey:rhs] operator_Pre]){
		return YES;
	}
	return  NO;
}
-(bool) precedenceOfThis:(NSString*) lhs isEqualTo:(NSString*) rhs{
	if([[ _FnOp_dict objectForKey:lhs] operator_Pre] ==
	   [[ _FnOp_dict objectForKey:rhs] operator_Pre]){
		return YES;
	}
	return  NO;
}
/*brief: using the MathFnName found in the _compiledOpArr as a key
 for the dictionary.  It will retrieve the correct enum to decide what
 action should be taken.
 
 for example:
 get top of _compiledOpArr then pop top.
 then pop off from the _compiledTermArr the number of elements the
 specific math requires. generate a result then add to _compiledTermArr
 
 i.e. perform add
 -switch will pick FN_ADD
 -since add requires two numbers it will pop 2 elements and save them in 2 variables
 -the add will be done and the answer will be pushed onto _compiledTermArr
 
 return: if able to perform then return yes, otherwise no
 */
-(bool) PerformMathFunct:(NSString*) mathFnName{
	bool pass = true;
	int switchnum =[[_FnOp_dict objectForKey:mathFnName] function_id];
	if(DEBUGGING)printf("[%s,%d] ", [mathFnName UTF8String], switchnum);
	switch (switchnum) {
			double a,b;
		case FN_NEG:
			a = [[self getTopOfArrAndPop:_compiledTermArr] floatValue];
			[_compiledTermArr addObject:[NSString stringWithFormat:@"%f", -a]];
			if(DEBUGGING){printf("not(%f) =%f\n",a, [[_compiledTermArr lastObject] floatValue]);}
			break;
		case FN_EXPONENT:
			b = [[self getTopOfArrAndPop:_compiledTermArr] floatValue];
			a = [[self getTopOfArrAndPop:_compiledTermArr] floatValue];
			a = powf(a,b);
			[_compiledTermArr addObject:[NSString stringWithFormat:@"%f", a]];
			if(DEBUGGING){printf("%f ^ %f = (%f)\n",a, b, [[_compiledTermArr lastObject] floatValue]);}
			break;
		case FN_MULT:
			b = [[self getTopOfArrAndPop:_compiledTermArr] floatValue];
			a = [[self getTopOfArrAndPop:_compiledTermArr] floatValue];
			[_compiledTermArr addObject:[NSString stringWithFormat:@"%f", a*b]];
			if(DEBUGGING){printf("%f * %f = (%f)\n",a, b, [[_compiledTermArr lastObject] floatValue]);}
			break;
		case FN_DIV:
			
			b = [[self getTopOfArrAndPop:_compiledTermArr] floatValue];
			a = [[self getTopOfArrAndPop:_compiledTermArr] floatValue];
			[_compiledTermArr addObject:[NSString stringWithFormat:@"%f", a/b]];
			if(DEBUGGING){printf("%f / %f = (%f)\n",a, b, [[_compiledTermArr lastObject] floatValue]);}
			break;
		case FN_ADD:
			b = [[self getTopOfArrAndPop:_compiledTermArr] floatValue];
			a = [[self getTopOfArrAndPop:_compiledTermArr] floatValue];
			[_compiledTermArr addObject:[NSString stringWithFormat:@"%f", a+b]];
			if(DEBUGGING){printf("%f + %f = (%f)\n",a, b, [[_compiledTermArr lastObject] floatValue]);}
			break;
		case FN_SUB:
			b = [[self getTopOfArrAndPop:_compiledTermArr] floatValue];
			a = [[self getTopOfArrAndPop:_compiledTermArr] floatValue];
			[_compiledTermArr addObject:[NSString stringWithFormat:@"%f", a-b]];
			if(DEBUGGING){printf("%f - %f = (%f)\n",a, b, [[_compiledTermArr lastObject] floatValue]);}
			break;
		default:
			[self error:(@"could not perform math")];
			pass = false ;
			break;
	}
	return pass;
}
-(NSString*) getTopOfArrAndPop:(NSMutableArray*) arr{
	NSString* ret = nil;
	if (arr.count) {
		ret = [NSString stringWithString: [arr lastObject]];
		[arr removeLastObject];
	}else{
		[self error:(@"can't pop an empty array")];
	}
	return ret;
}
-(void) solveParentheses{
	
	if( [self isParenthesesBegin:[_parserArr objectAtIndex:_parserLine]] ){
		_parserLine++;
		for(; ![self isParenthesesEnd:[_parserArr objectAtIndex:_parserLine]];_parserLine++	){
			if([self isExpressionBegin:[_parserArr objectAtIndex:_parserLine]]){
				[self solveExpression];
			}else{
				[self error:(@"expected an expression inside (...)")];
			}
			if ( _parserArr == nil ){ return;}
		}
	}else{
		[self error:(@"expected expression")];
	}
}
-(void) solveTerminal{//handles the numbers that get pushed onto the _compiledTermArr
	if( [self isTermBegin:[_parserArr objectAtIndex:_parserLine++]]){
		while (![self isTermEnd:[_parserArr objectAtIndex:_parserLine]]) {
			NSString* currline = [_parserArr objectAtIndex:_parserLine];
			if ([self containedInString:currline isThisValue:TAG_INTEGER_OPEN]) {
				[_compiledTermArr addObject:[self extractItemFromString:currline]];
			}else if ([self containedInString:currline isThisValue:TAG_FLOAT_OPEN]) {
				[_compiledTermArr addObject:[self extractItemFromString:currline]];
			}else if ([self containedInString:currline isThisValue:TAG_FUNCTION_OPEN]) {
				[self solveFunction];
			}else if([self containedInString:currline
									   isTag:TAG_SYMBOL_OPEN
							   isMiddleValue:ITEM_PARENTHESES_OPEN]
					 ){
				[self solveParentheses];
			}else{
				[self error:(@" unhandled term contents")];
			}
			if ( _parserArr == nil ){ return;}
			_parserLine++;
		}
	}else{
		[self error:(@"expected term")];
	}
}
-(void) solveFunction{
	if ([self isFunctionBegin:[_parserArr objectAtIndex:_parserLine++]]) {
		NSString* fnName = nil;
		while ( ![self isFunctionEnd:[_parserArr objectAtIndex:_parserLine]]) {
			NSString* currline = [_parserArr objectAtIndex:_parserLine];
			if ([self containedInString:currline
							isThisValue:TAG_IDENTIFIER_OPEN]) {
				//get the function name
				fnName = [self extractItemFromString:currline];
			}else if( [self isParenthesesBegin:currline]){
				_parserLine++;//move past "("
				if ([self isExpressionListBegin:[_parserArr objectAtIndex:_parserLine]]) {
					[self solveExpressionList];
				}else{
					[self error:(@"expected expression List")];
				}
				if ( _parserArr == nil){ return;}
				_parserLine++;//move to ")"
			}
			_parserLine++;
		}
		//code to perfrom the function
		[self PerformMathFunct:fnName];
		
	}else{
		[self error:(@"expected function call")];
	}
}
-(NSString*) extractItemFromString:(NSString*) line{
	NSRange left,right;
	left = [line rangeOfString:@"> "];
	line = [line substringFromIndex:left.location+left.length];
	right = [line rangeOfString:@" </"];
	return [line substringToIndex:right.location];
}
-(BOOL) isExpressionBegin:(NSString*) line{
	if( [self containedInString:line isThisValue:TAG_EXPRESSION_OPEN]){
		return YES;
	}
	return NO;
}
-(BOOL) isExpressionEnd:(NSString*) line{
	if( [self containedInString:line isThisValue:TAG_EXPRESSION_CLOSE]){
		return YES;
	}
	return NO;
}
-(BOOL) isExpressionListBegin:(NSString*) line{
	if( [self containedInString:line isThisValue:TAG_EXPRESSION_LIST_OPEN]){
		return YES;
	}
	return NO;
}
-(BOOL) isExpressionListEnd:(NSString*) line{
	if( [self containedInString:line isThisValue:TAG_EXPRESSION_LIST_CLOSE]){
		return YES;
	}
	return NO;
}
-(bool) isFunctionBegin:(NSString*) line{
	if( [self containedInString:line isThisValue:TAG_FUNCTION_OPEN]){
		return YES;
	}
	return NO;
}
-(bool) isFunctionEnd:(NSString *) line{
	if( [self containedInString:line isThisValue:TAG_FUNCTION_CLOSE]){
		return YES;
	}
	return NO;
}
-(BOOL) isParenthesesBegin:(NSString*) line{
	if( [self containedInString:line isTag:TAG_SYMBOL_OPEN isMiddleValue:ITEM_PARENTHESES_OPEN]){
		return YES;
	}
	return NO;
}
-(BOOL) isParenthesesEnd:(NSString*) line{
	if( [self containedInString:line isTag:TAG_SYMBOL_OPEN isMiddleValue:ITEM_PARENTHESES_CLOSE]){
		return YES;
	}
	return NO;
}
-(BOOL) isTermBegin:(NSString*) line{
	if( [self containedInString:line isThisValue:TAG_TERM_OPEN]){
		return YES;
	}
	return NO;
}
-(BOOL) isTermEnd:(NSString*) line{
	if( [self containedInString:line isThisValue:TAG_TERM_CLOSE]){
		return YES;
	}
	return NO;
}

-(NSString*) CalculatedAnswerAsString:(NSString*) expression{
	
	_origExpression = expression;
	[self TokenizeString];
		if (_tokenArr == nil ){ return nil;}
	if(DEBUGGING){
		printf("================token\n");
		for (NSString* s in _tokenArr) {
			printf("%s\n", [s UTF8String]);
		}//tokenize appears to be working
	}
	
	[self ParserToEncapsulateExpression];
		if ( _parserArr == nil ){ return nil;}
	if(DEBUGGING){
		printf("================parse\n");
		for (NSString* s in _parserArr) {
			printf("%s\n", [s UTF8String]);
		}//parser appears to be working
		printf("================\n");
	}
	_parserLine = 0;
	_compiledTermArr = [NSMutableArray new];
	
	[self solveExpression] ;
	if ( _compiledTermArr == nil){ return nil;}
	if(DEBUGGING){
		for(NSString* s in _compiledTermArr){
			printf("%s\n", [s UTF8String]);
		}
	}
	return [_compiledTermArr lastObject] ;
	
SEND_INVALID:
	return @"invalid equation";
}
-(float) CalculatedAnswerAsFloat:(NSString*) expression{
	float num = [[self CalculatedAnswerAsString:expression] floatValue];
	
	return num;
}

-(void) error:(NSString *)I{
	NSLog(@"%@", I);
	_parserArr = nil;
	_tokenArr = nil;
	_compiledTermArr = nil;
}

@end

NSString* formatNumber( NSString* s){
	s = [NSString stringWithFormat:@"%.5f", [s doubleValue]];
	
	if( [s rangeOfString:@".00000"].location != NSNotFound){
		s = [NSString stringWithFormat:@"%d", [s integerValue]];
	}else if( [s characterAtIndex:s.length-1] != '0'){
		//do nothing
	}else{
		while( [s characterAtIndex:s.length-1] == '0'){
			s = [s substringToIndex:s.length-1];
		}
	}
	return s;
}
//void error(NSString * I) {
//	printf("%s\n", [I UTF8String]);
//	exit(0);
/*I am not certain how to properly get rid of the error state.
 The error state exits the program.  There should be a way
 to make the "CalculatedAnswerAsString" return a string of error.
 
 But as it stands the moment error() is called it could be deep in a recurive
 nest.  The question is how to get up to the top again in an elegant way.
 
Might require a redesign, but i guess that will have to wait until the next revision.
 */
//}

