//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDIterable.h"

#pragma mark Enumerate

void REDEnumerate(REDIteratingBlock iterator, void(^block)(id each)) {
	id each;
	while ((each = iterator())) {
		block(each);
	}
}

l3_addTestSubjectTypeWithFunction(REDEnumerate)
l3_test(&REDEnumerate) {
	REDIteratingBlock iterator = REDIteratorWithFastEnumeration(@[ @"a", @"b", @"c" ]);
	__block NSString *iterated = @"";
	REDEnumerate(iterator, ^(NSString *each) {
		iterated = [iterated stringByAppendingString:each];
	});
	NSString *full = @"abc";
	l3_expect(iterated).to.equal(full);
}


#pragma mark Categories

@implementation NSArray (REDIterable)

-(REDIteratingBlock)red_iterator {
	return REDIteratorWithFastEnumeration(self);
}

@end


#pragma mark Conveniences

REDIteratingBlock REDIteratorWithFastEnumeration(id<NSFastEnumeration> collection) {
	typedef struct {
		NSFastEnumerationState state;
		id __unsafe_unretained objects[16];
		id __unsafe_unretained *current;
		id __unsafe_unretained *stop;
	} REDEnumeratorState;
	__block REDEnumeratorState state = {0};
	
	static NSUInteger (^refill)(id<NSFastEnumeration>, REDEnumeratorState *) = ^NSUInteger (id<NSFastEnumeration> collection, REDEnumeratorState *state) {
		if (state->current >= state->stop) {
			NSUInteger count = [collection countByEnumeratingWithState:&state->state objects:state->objects count:sizeof state->objects / sizeof *state->objects];
			state->current = state->state.itemsPtr;
			state->stop = state->current + count;
		}
		return state->stop - state->current;
	};
	
	return ^{
		return refill(collection, &state) > 0?
			*state.current++
		:	nil;
	};
}

l3_addTestSubjectTypeWithFunction(REDIteratorWithFastEnumeration)
l3_test(&REDIteratorWithFastEnumeration) {
	REDIteratingBlock block = REDIteratorWithFastEnumeration(@[ @1, @2, @3, @4 ]);
	id each;
	id into = @"";
	while ((each = block())) {
		into = [into stringByAppendingString:[each description]];
	}
	l3_expect(into).to.equal(@"1234");
}

