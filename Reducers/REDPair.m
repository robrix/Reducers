//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDPair.h"

@implementation NSArray (REDKeyValuePair)

-(id<NSCopying>)red_key {
	return self.firstObject;
}

-(id)red_value {
	return self.lastObject;
}

@end
