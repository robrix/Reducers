//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDAppendable.h"
#import "REDConvolve.h"
#import "REDMap.h"
#import "REDReducer.h"
#import "REDIterable.h"

#pragma mark Convolve

@interface REDConvolver : NSObject <REDReducible, REDIterable>

+(instancetype)convolverWithReducibles:(id<REDReducible>)reducibles convolution:(REDConvolutionBlock)convolution;

@end

id<REDIterable, REDReducible> REDConvolve(id<REDReducible> reducibles, REDConvolutionBlock convolution) {
	return [REDConvolver convolverWithReducibles:reducibles convolution:convolution];
}


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


#pragma mark REDIterable

-(REDIteratingBlock)red_iterator {
	NSArray *iterators = [NSArray red_append:REDMap(_reducibles, ^id (id<REDIterable> each) {
		return each.red_iterator;
	})];
	
	NSUInteger count = iterators.count;
	
	__block id __strong *objects = (id __strong *)calloc(count, sizeof(id __strong));
	
	return ^{
		id convolved;
		id __strong *next = objects;
		if (objects == NULL) goto done;
		
		for (REDIteratingBlock iterator in iterators) {
			id object = iterator();
			if (object == nil) {
				free(objects);
				objects = NULL;
				goto done;
			}
			*next++ = object;
		}
		
		convolved = obstr_block_apply(_convolution, count, objects);
		
		done:
		
		return convolved;
	};
}

l3_test(@selector(red_iterator)) {
	REDIteratingBlock iterator = REDConvolve(@[ @"one", @"two", @"three" ], ^(NSString *a, NSString *b, NSString *c) {
		return [[a stringByAppendingString:b] stringByAppendingString:c];
	}).red_iterator;
	__block NSString *joined = @"";
	REDEnumerate(iterator, ^(NSString *each) {
		joined = [joined stringByAppendingString:each];
	});
	l3_expect(joined).to.equal(@"ottnwheor");
}


#pragma mark REDReducible

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	NSArray *enumerators = [NSArray red_append:REDMap(_reducibles, ^id (id<REDIterable> each) {
		return each.red_iterator;
	})];
	
	id enumerated[enumerators.count];
	while (1) {
		id __strong *next = enumerated;
		for (id(^enumerator)() in enumerators) {
			id object = enumerator();
			if (!object) goto done;
			*next++ = object;
		}
		
		unsigned long count = sizeof enumerated / sizeof *enumerated;
		id __strong *all = enumerated;
		initial = block(initial, obstr_block_apply(_convolution, count, all));
	}
	
	done:
	
	return initial;
}

l3_test(@selector(red_reduce:usingBlock:)) {
	NSArray *convolution = [NSArray red_append:REDConvolve(@[ @"fish", @"face" ], ^(NSString *a, NSString *b) {
		return [a stringByAppendingString:b];
	})];
	l3_expect(convolution).to.equal(@[ @"ff", @"ia", @"sc", @"he" ]);
}

@end
