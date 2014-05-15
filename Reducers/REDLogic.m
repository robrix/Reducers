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
	__block NSUInteger outerEffects = 0;
	id<REDReducible> map = REDMap(@[ @"a", @"b", @"c" ], ^(id each) {
		++outerEffects;
		return (id)nil;
	});
	l3_expect(REDAnd(map)).to.equal(nil);
	
	l3_expect(outerEffects).to.equal(@1);
}


id REDOr(id<REDReducible> collection, REDMapBlock map) {
	return [collection red_reduce:nil usingBlock:^(id into, id each) {
		return into ?: map(each);
	}];
}

l3_addTestSubjectTypeWithFunction(REDOr)
l3_test(&REDOr) {
	l3_expect(REDOr(@[ @1, @2 ], ^(NSNumber *each) { return each.unsignedIntegerValue % 2 == 0? each : nil; })).to.equal(@2);
}
