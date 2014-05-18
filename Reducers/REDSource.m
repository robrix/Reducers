//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDSource.h"

@interface NSObject (REDObject)

-(instancetype)red_object;

@end


@implementation REDSource

#pragma mark REDIterable

-(REDIteratingBlock)red_iterator {
	return ^{
		return self.sample;
	};
}


#pragma mark REDReducible

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	__block id into = initial;
	REDEnumerate(self.red_iterator, ^(id each, bool *stop) {
		into = block(into, each);
		*stop = into != [into self];
	});
	return [into self];
}

@end


@implementation NSObject (REDObject)

-(instancetype)red_object {
	return self;
}

@end

@implementation NSNull (REDObject)

-(instancetype)red_object {
	return nil;
}

@end
