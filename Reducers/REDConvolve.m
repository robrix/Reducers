//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDConvolve.h"
#import "REDReducer.h"

#pragma mark Convolve

@interface REDConvolver : NSObject <REDReducible>

+(instancetype)convolverWithReducibles:(id<REDReducible>)reducibles convolution:(REDConvolutionBlock)convolution;

@end

id<REDReducible> REDConvolve(id<REDReducible> reducibles, REDConvolutionBlock convolution) {
	return [REDConvolver convolverWithReducibles:reducibles convolution:convolution];
}


#pragma mark Array



#pragma mark Convolution

@implementation REDConvolver {
	id<REDReducible> _reducibles;
	REDConvolutionBlock _convolution;
}

+(instancetype)convolverWithReducibles:(id<REDReducible>)reducibles convolution:(REDConvolutionBlock)convolution {
	return [[self alloc] initWithReducibles:reducibles convolution:convolution];
}

-(instancetype)initWithReducibles:(id<REDReducible>)reducibles convolution:(REDConvolutionBlock)convolution {
	if ((self = [super init])) {
		_reducibles = reducibles;
		_convolution = [convolution copy];
	}
	return self;
}

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	// a = [1, 2, 3]
	// b = [4, 5, 6]
	// c = [7, 8, 9]
	// all = [a, b, c]
	//
	// call(a1, b4, c7)
	// call(a2, b5, c8)
	// call(a3, b6, c9)
	//
	// a
	// 1
	//   \
	//     b
	//     4
	//       \
	//         c
	//         7
	//   <----
	// a
	// 2
	//   \
	//     etc
	//
	return [_reducibles red_reduce:_reducibles usingBlock:^(id<REDReducible> reducibles, id<REDReducible> reducible) {
		return [reducible red_reduce:initial usingBlock:^(id into, id each) {
			return into;
		}];
	}];
}

@end
