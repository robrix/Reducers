//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDIdiom.h"

#pragma mark Categories

@implementation NSArray (REDIdiom)

-(id<REDReducible>)red_map:(REDMapBlock)map {
	return REDMap(self, map);
}

-(id<REDReducible>)red_flattenMap:(REDFlattenMapBlock)map {
	return REDFlattenMap(self, map);
}

-(id<REDReducible>)red_filter:(REDPredicateBlock)predicate {
	return REDFilter(self, predicate);
}

@end
