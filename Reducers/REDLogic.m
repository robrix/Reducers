//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDLogic.h"
#import "REDMap.h"

#pragma mark Logic

id REDAnd(id<REDReducible> collection) {
	id marker = [NSObject new];
	id found = [collection red_reduce:marker usingBlock:^(id into, id each) {
		return into?
			each ?: [REDReduced reduced:nil]
		:	nil;
	}];
	
	return (found != marker)?
		found
	:	marker;
}

l3_addTestSubjectTypeWithFunction(REDAnd)
l3_test(&REDAnd) {
	__block NSUInteger effects = 0;
	NSArray *collection = @[ @"a", @"b", @"c" ];
	l3_expect(REDAnd(collection)).to.equal(collection.lastObject);
	
	id<REDReducible> map = REDMap(collection, ^(id each) {
		++effects;
		return (id)nil;
	});
	l3_expect(REDAnd(map)).to.equal(nil);
	
	l3_expect(effects).to.equal(@1);
}


id REDOr(id<REDReducible> collection) {
	return [collection red_reduce:nil usingBlock:^(id into, id each) {
		return into?
			[REDReduced reduced:into]
		:	each;
	}];
}

l3_test(&REDOr) {
	__block NSUInteger effects = 0;
	id<REDReducible> map = REDMap(@[ @1, @2, @3, @4 ], ^(NSNumber *each) {
		++effects;
		return each.unsignedIntegerValue % 2 == 0? each : nil;
	});
	l3_expect(REDOr(map)).to.equal(@2);
}
