//
//  DHPair.h
//  TellerCalculator
//
//  Created by Derrick Ho on 5/17/13.
//  Copyright (c) 2013 Derrick Ho. All rights reserved.
//

#import <Foundation/Foundation.h>
enum operator_precedence{
	OP_FUNC = 0,
	OP_UNARY = 0,
	OP_EXPONENT = -1,
	OP_MULT = -2,
	OP_DIV = -2,
	OP_ADD = -3,
	OP_SUB = -3
};
enum fn_list{
	FN_NEG=6,
	FN_EXPONENT=5,
	FN_MULT=4,
	FN_DIV=3,
	FN_ADD=2,
	FN_SUB=1
};

@interface  pair_fn_op: NSObject {
	enum fn_list function_id;
	enum operator_precedence operator_Pre;
}

+(id) MakeFnOpPair: (enum fn_list) function_id : (enum operator_precedence) operator_Pr;
@property (assign) enum fn_list function_id;
@property (assign) enum operator_precedence operator_Pre;
@end;
