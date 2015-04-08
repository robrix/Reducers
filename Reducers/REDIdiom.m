//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDAppendable.h"
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

l3_test(@selector(red_filter:)) {
	NSArray *collection = @[ @"how", @"who", @"hear" ];
	REDPredicateBlock startsWithH = ^bool (NSString *each) {
		return [each hasPrefix:@"h"];
	};
	NSString *expected = @"howhear";
	
	// regular
	l3_expect([@"" red_append:REDFilter(collection, startsWithH)]).to.equal(expected);
	
	// idiomatic (?)
	l3_expect([@"" red_append:[collection red_filter:startsWithH]]).to.equal(expected);
}


-(id<REDReducible>)red_join:(id)separator {
	return REDJoin(self, separator);
}

l3_test(@selector(red_join:)) {
	l3_expect([@"" red_append:[@[ @"f", @"o", @"r", @"k" ] red_join:@" "]]).to.equal(@"f o r k");
}


-(id<REDIterable, REDReducible>)red_convolve:(REDConvolutionBlock)convolution {
	return REDConvolve(self, convolution);
}

l3_test(@selector(red_convolve:)) {
	NSArray *collections = @[ @"pork", @"rind" ];
	REDConvolutionBlock convolution = ^(NSString *a, NSString *b) {
		return [a stringByAppendingString:b];
	};
	NSString *interleaved = @"proirnkd";
	
	// regular
	l3_expect([@"" red_append:REDConvolve(collections, convolution)]).to.equal(interleaved);
	
	// idiomatic (?)
	l3_expect([@"" red_append:[collections red_convolve:convolution]]).to.equal(interleaved);
}

@end
