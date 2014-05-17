//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDSource.h"

@implementation REDSource

#pragma mark REDIterable

-(REDIteratingBlock)red_iterator {
	return ^{
		return (id)nil;
	};
}


#pragma mark REDReducible

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	return nil;
}

@end
