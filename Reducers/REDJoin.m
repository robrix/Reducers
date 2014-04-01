//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDJoin.h"

id<REDReducible> REDJoin(id<REDReducible> collection, id separator) {
	return nil;
}

l3_addTestSubjectTypeWithFunction(REDJoin)
l3_test(&REDJoin) {
	NSString *(^append)(NSString *, id) = ^(NSString *into, id each) { return [into stringByAppendingString:[each description]]; };
	id<REDReducible> reducible = @[ @0, @1, @2, @3 ];
	id separator = @".";
	
	id into = @"";
	id joined = @"0.1.2.3";
	l3_expect([REDJoin(reducible, separator) red_reduce:into usingBlock:append]).to.equal(joined);
}
