//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDIdiom.h"
#import "REDJoin.h"

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


-(id<REDReducible>)red_join:(id)separator {
	return REDJoin(self, separator);
}


-(id<REDIterable, REDReducible>)red_convolve:(REDConvolutionBlock)convolution {
	return REDConvolve(self, convolution);
}
@end
