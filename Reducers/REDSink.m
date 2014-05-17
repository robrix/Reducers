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
	
	return nil;
}

@end
