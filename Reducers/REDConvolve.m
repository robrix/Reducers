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
	return nil;
}

@end
