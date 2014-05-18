//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDReducer.h"

@implementation REDReducer {
	id<REDIterable, REDReducible> _reducible;
	REDReducingTransformerBlock _transformer;
}

+(instancetype)reducerWithReducible:(id<REDIterable, REDReducible>)reducible transformer:(REDReducingTransformerBlock)transformer {
	return [[self alloc] initWithReducible:reducible transformer:transformer];
}

-(instancetype)initWithReducible:(id<REDIterable, REDReducible>)reducible transformer:(REDReducingTransformerBlock)transformer {
	if ((self = [super init])) {
		_reducible = reducible;
		_transformer = [transformer copy];
	}
	return self;
}


#pragma mark REDIterable

-(REDIteratingBlock)red_iterator {
	REDReducingBlock transformed = _transformer(^(id into, id each) { return each; });
	REDIteratingBlock iterator = _reducible.red_iterator;
	return ^{
		return transformed(nil, iterator());
	};
}


#pragma mark REDReducible

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	return [_reducible red_reduce:initial usingBlock:_transformer(block)];
}

@end
