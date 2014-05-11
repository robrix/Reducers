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


id REDOr(id<REDReducible> collection, REDMapBlock map) {
	return [collection red_reduce:nil usingBlock:^(id into, id each) {
		return into ?: map(each);
	}];
}
