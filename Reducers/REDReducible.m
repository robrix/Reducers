//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDReducible.h"

#pragma mark Categories

static inline id REDStrictReduce(id<NSFastEnumeration> collection, id initial, REDReducingBlock block) {
	for (id each in collection) {
		initial = block(initial, each);
	}
	return initial;
}

l3_addTestSubjectTypeWithFunction(REDStrictReduce)
l3_test(&REDStrictReduce) {
	NSArray *collection = @[ @"a", @"b", @"c" ];
	id initial;
	id (^each)(id, id) = ^(id into, id each) { return each; };
	l3_expect(REDStrictReduce(collection, initial, each)).to.equal(collection.lastObject);
}


static inline id REDStrictReduceRight(id<NSFastEnumeration> collection, id initial, REDReducingBlock block) {
	id (^into)(id) = ^(id x) { return x; };
	for (id each in collection) {
		into = ^(id rest) {
			return into(block(rest, each));
		};
	}
	return into(initial);
}

l3_test(&REDStrictReduceRight) {
	NSArray *collection = @[ @"a", @"b", @"c" ];
	id initial = @"";
	id (^each)(id, id) = ^(id into, id each) { return each; };
	l3_expect(REDStrictReduceRight(collection, initial, each)).to.equal(collection.firstObject);
}


typedef id(^REDEnumeratorBlock)();
REDEnumeratorBlock REDEnumerator(id<NSFastEnumeration> collection) {
	__block struct {
		NSFastEnumerationState state;
		id __unsafe_unretained objects[16];
		id __unsafe_unretained *current;
		id __unsafe_unretained *stop;
	} state = {0};
	
	NSUInteger (^refill)() = ^NSUInteger {
		if (state.current >= state.stop) {
			NSUInteger count = [collection countByEnumeratingWithState:&state.state objects:state.objects count:sizeof state.objects / sizeof *state.objects];
			state.current = state.state.itemsPtr;
			state.stop = state.current + count;
		}
		return state.stop - state.current;
	};
	
	return ^{
		return refill() > 0?
			*state.current++
		:	nil;
	};
}

l3_addTestSubjectTypeWithFunction(REDEnumerator)
l3_test(&REDEnumerator) {
	REDEnumeratorBlock block = REDEnumerator(@[ @1, @2, @3, @4 ]);
	id each;
	id into = @"";
	while ((each = block())) {
		into = [into stringByAppendingString:[each description]];
	}
	l3_expect(into).to.equal(@"1234");
}


@implementation NSArray (REDReducible)

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	return REDStrictReduce(self, initial, block);
}

@end


@implementation NSSet (REDReducible)

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	return REDStrictReduce(self, initial, block);
}

@end


@implementation NSOrderedSet (REDReducible)

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	return REDStrictReduce(self, initial, block);
}

l3_test(@selector(red_reduce:usingBlock:)) {
	NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithObjects:@0, @5, @3, @1, nil];
	NSNumber *(^subtract)(NSNumber *, NSNumber *) = ^(NSNumber *into, NSNumber *each) { return @(into.integerValue - each.integerValue); };
	l3_expect([orderedSet red_reduce:@0 usingBlock:subtract]).to.equal(@-9);
}

@end


@implementation NSDictionary (REDReducible)

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	return REDStrictReduce(self, initial, block);
}

l3_test(@selector(red_reduce:usingBlock:)) {
	NSSet *(^append)(NSSet *, id) = ^(NSSet *into, id each) { return [into setByAddingObject:each]; };
	NSDictionary *dictionary = @{ @"z": @'z', @"x": @'x', @"y": @'y', };
	NSSet *into = [NSSet set];
	l3_expect([dictionary red_reduce:into usingBlock:append]).to.equal([NSSet setWithArray:dictionary.allKeys]);
}

@end


@implementation NSString (REDReducible)

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	__block id result = initial;
	[self enumerateSubstringsInRange:(NSRange){ .length = self.length } options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
		result = block(result, substring);
	}];
	return result;
}

l3_test(@selector(red_reduce:usingBlock:)) {
	NSString *(^append)(NSString *, id) = ^(NSString *into, NSString *each) { return [into stringByAppendingString:each]; };
	NSString *original = @"12345∆π¬µ∂🚑👖🐢🎈🔄";
	l3_expect([original red_reduce:@"" usingBlock:append]).to.equal(original);
}

@end


@implementation NSAttributedString (REDReducible)

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	__block id result = initial;
	[self.string enumerateSubstringsInRange:(NSRange){ .length = self.length } options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
		result = block(result, [self attributedSubstringFromRange:substringRange]);
	}];
	return result;
}

l3_test(@selector(red_reduce:usingBlock:)) {
	NSAttributedString *(^append)(NSAttributedString *, NSAttributedString *) = ^(NSAttributedString *into, NSAttributedString *each) {
		NSMutableAttributedString *copy = [into mutableCopy];
		[copy appendAttributedString:each];
		return copy;
	};
	NSAttributedString *original = [[NSAttributedString alloc] initWithString:@"♬🐡😠" attributes:@{ @"key": @"value" }];
	l3_expect([original red_reduce:[NSAttributedString new] usingBlock:append]).to.equal(original);
}

@end


@implementation NSEnumerator (REDReducible)

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	id each;
	while ((each = [self nextObject])) {
		initial = block(initial, each);
	}
	return initial;
}

l3_test(@selector(red_reduce:usingBlock:)) {
	NSEnumerator *enumerator = [@[ @1, @2, @3 ] reverseObjectEnumerator];
	NSMutableArray *into = [NSMutableArray new];
	NSMutableArray *(^append)(NSMutableArray *, id) = ^(NSMutableArray *into, id each) {
		[into addObject:each];
		return into;
	};
	l3_expect([enumerator red_reduce:into usingBlock:append]).to.equal(@[ @3, @2, @1 ]);
}

@end
