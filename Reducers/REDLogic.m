//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDLogic.h"
#import "REDMap.h"

#pragma mark Logic

id REDAnd(id<REDReducible> collection, REDMapBlock map) {
	id marker = [NSObject new];
	id found = [collection red_reduce:marker usingBlock:^(id into, id each) {
		return into?
			map(each)
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
		return @(outerEffects++);
	});
	__block NSUInteger innerEffects = 0;
	l3_expect(REDAnd(map, ^(id each) {
		++innerEffects;
		return (id)nil;
	})).to.equal(nil);
	
	l3_expect(outerEffects).to.equal(@3);
	l3_expect(innerEffects).to.equal(@1);
}


id REDOr(id<REDReducible> collection, REDMapBlock map) {
	return [collection red_reduce:nil usingBlock:^(id into, id each) {
		return into ?: map(each);
	}];
}
