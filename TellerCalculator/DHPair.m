//
//  DHPair.m
//  TellerCalculator
//
//  Created by Derrick Ho on 5/17/13.
//  Copyright (c) 2013 Derrick Ho. All rights reserved.
//

#import "DHPair.h"

@implementation pair_fn_op
@synthesize function_id, operator_Pre;

+(id) MakeFnOpPair: (enum fn_list) fn_id : (enum operator_precedence) op_Pre{
	pair_fn_op * instance = [pair_fn_op new];
	[instance setFunction_id:fn_id];
	[instance setOperator_Pre:op_Pre];
	return instance ;
}

@end