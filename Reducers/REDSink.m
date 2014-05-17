//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDSink.h"

@implementation REDSink

+(instancetype)sinkWithBlock:(REDSinkBlock)block {
	return [[self alloc] initWithBlock:block];
}

-(instancetype)initWithBlock:(REDSinkBlock)block {
	if ((self = [super init])) {
		_block = [block copy];
	}
	return self;
}


#pragma mark REDAppendable

+(instancetype)red_append:(id<REDReducible>)from {
	return [[[self alloc] initWithBlock:^(id _){}] red_append:from];
}

-(instancetype)red_append:(id<REDReducible>)from {
	return [from red_reduce:self usingBlock:^(REDSink *into, id each) {
		into->_block(each);
		return into;
	}];
}

l3_test(@selector(red_append:)) {
	NSMutableArray *appendee = [NSMutableArray new];
	REDSink *appender = [REDSink sinkWithBlock:^(id each) {
		[appendee addObject:each];
	}];
	id<REDReducible> reducible = @[ @0, @1, @2, @3 ];
	[appender red_append:reducible];
	l3_expect(appendee).to.equal(reducible);
}

@end
