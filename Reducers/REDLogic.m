//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDLogic.h"
#import "REDMap.h"

id REDAnd(id<REDReducible> collection) {
	id marker = [NSObject new];
	id found = [collection red_reduce:marker usingBlock:^(id into, id each) {
		return into?
			each
		:	nil;
	}];
	
	return (found != marker)?
		found
	:	marker;
}


id REDOr(id<REDReducible> collection) {
	return [collection red_reduce:nil usingBlock:^id(id into, id each) {
		return into ?: each;
	}];
}
