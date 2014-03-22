//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDReducer.h"

@implementation REDReducer {
	id<REDReducible> _reducible;
	REDReducingTransformerBlock _transformer;
}

+(instancetype)reducerWithReducible:(id<REDReducible>)reducible transformer:(REDReducingTransformerBlock)transformer {
	return [[self alloc] initWithReducible:reducible transformer:transformer];
}

-(instancetype)initWithReducible:(id<REDReducible>)reducible transformer:(REDReducingTransformerBlock)transformer {
	if ((self = [super init])) {
		_reducible = reducible;
		_transformer = [transformer copy];
	}
	return self;
}


#pragma mark REDReducible

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	return [_reducible red_reduce:initial usingBlock:_transformer(block)];
}

@end
