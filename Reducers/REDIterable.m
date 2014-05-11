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


@implementation NSSet (REDIterable)

-(REDIteratingBlock)red_iterator {
	return REDIteratorWithFastEnumeration(self);
}

@end


@implementation NSOrderedSet (REDIterable)

-(REDIteratingBlock)red_iterator {
	return REDIteratorWithFastEnumeration(self);
}

@end


@implementation NSDictionary (REDIterable)

-(REDIteratingBlock)red_iterator {
	return REDIteratorWithFastEnumeration(self);
}

@end


@implementation NSString (REDIterable)

-(REDIteratingBlock)red_iterator {
	__block NSRange range = {0};
	return ^{
		return NSMaxRange(range) < self.length?
			[self substringWithRange:range = [self rangeOfComposedCharacterSequenceAtIndex:NSMaxRange(range)]]
		:	nil;
	};
}

l3_test(@selector(red_iterator)) {
	__block NSUInteger count = 0;
	REDEnumerate(@" ∆♬🍁☃ü".red_iterator, ^(NSString *each) {
		count++;
	});
	l3_expect(count).to.equal(@6);
}

@end


@implementation NSAttributedString (REDIterable)

-(REDIteratingBlock)red_iterator {
	__block NSRange range = {0};
	return ^{
		return NSMaxRange(range) < self.length?
			[self attributedSubstringFromRange:range = [self.string rangeOfComposedCharacterSequenceAtIndex:NSMaxRange(range)]]
		:	nil;
	};
}

@end


@implementation NSEnumerator (REDIterable)

-(REDIteratingBlock)red_iterator {
	return ^{
		return [self nextObject];
	};
}

l3_test(@selector(red_iterator)) {
	__block id last;
	REDEnumerate(@[ @0, @1, @2 ].reverseObjectEnumerator.red_iterator, ^(id each) {
		last = each;
	});
	l3_expect(last).to.equal(@0);
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

