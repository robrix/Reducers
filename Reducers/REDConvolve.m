//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDAppendable.h"
#import "REDConvolve.h"
#import "REDMap.h"
#import "REDReducer.h"

@protocol REDIterable <NSObject>

@property (readonly) id(^red_iterator)(void);

@end

@interface NSString (REDIterable) <REDIterable>
@end
@implementation NSString (REDIterable)

-(id (^)(void))red_iterator {
	__block NSUInteger index = 0;
	return ^{
		return index < self.length?
			[self substringWithRange:[self rangeOfComposedCharacterSequenceAtIndex:index++]]
		:	nil;
	};
}

@end


#pragma mark Convolve

@interface REDConvolver : NSObject <REDReducible>

+(instancetype)convolverWithReducibles:(id<REDReducible>)reducibles convolution:(REDConvolutionBlock)convolution;

@end

id<REDReducible> REDConvolve(id<REDReducible> reducibles, REDConvolutionBlock convolution) {
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
