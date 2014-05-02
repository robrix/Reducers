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
	//  <-call-
	// a
	// 2
	//   \
	//     etc
	//
	
	NSMutableArray *queue = [NSMutableArray new];
	NSMutableArray *arguments = [NSMutableArray new];
	
	typedef void (^REDQueueBlock)(void);
	
	REDQueueBlock (^dequeue)(void) = ^{
		REDQueueBlock block = [queue firstObject];
		if (block) [queue removeObjectAtIndex:0];
		return block;
	};
	
	void(^run)(void) = ^{
		REDQueueBlock block;
		while ((block = dequeue())) {
			block();
		}
	};
	
	void(^enqueue)(REDQueueBlock) = ^(REDQueueBlock block) {
		[queue addObject:block];
	};
	
	// enqueue each column + the row col
	
	void (^callRow)(void) = ^{
		NSLog(@"arguments: %@", arguments);
		[arguments removeAllObjects];
		run();
	};
	
	REDQueueBlock flow = [_reducibles red_reduce:callRow usingBlock:^(REDQueueBlock block, id<REDReducible> column) {
		return (id)^{
			[column red_reduce:nil usingBlock:^(id _, id cell) {
				run();
				enqueue(^{
					[arguments addObject:cell];
				});
				return cell;
			}];
			
			enqueue(block);
		};
	}];
	
	flow();
	run();
	
	return nil;
}

l3_test(@selector(red_reduce:usingBlock:)) {
	REDConvolver *convolver = [[REDConvolver alloc] initWithReducibles:@[ @[ @1, @2, @3 ], @[ @4, @5, @6 ], @[ @7, @8, @9 ] ] convolution:^(id a, id b, id c){
		return @[ a, b, c ];
	}];
	
	NSArray *convoluted = [convolver red_reduce:nil usingBlock:^id(id into, id each) {
		return each;
	}];
	l3_expect(convoluted).to.equal(@[ @3, @6, @9 ]);
}

@end
