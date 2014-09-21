//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDReducible.h"

@implementation REDReduced

+(instancetype)reduced:(id)object {
	REDReduced *reduced = [self new];
	reduced->_self = object;
	return reduced;
}

@end

static inline id REDStrictReduce(id<NSFastEnumeration> collection, id initial, REDReducingBlock block) {
	for (id each in collection) {
		initial = block(initial, each);
		if (initial != [initial self]) break;
	}
	return [initial self];
}

l3_addTestSubjectTypeWithFunction(REDStrictReduce)
l3_test(&REDStrictReduce) {
	NSArray *collection = @[ @"a", @"b", @"c" ];
	id initial;
	id (^each)(id, id) = ^(id into, id each) { return each; };
	l3_expect(REDStrictReduce(collection, initial, each)).to.equal(collection.lastObject);
	
	id (^firstObject)(id, id) = ^(id into, id each) { return [REDReduced reduced:each]; };
	l3_expect(REDStrictReduce(collection, initial, firstObject)).to.equal(collection.firstObject);
}


#pragma mark Categories

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
		*stop = result != [result self];
	}];
	return [result self];
}

l3_test(@selector(red_reduce:usingBlock:)) {
	NSString *(^append)(NSString *, id) = ^(NSString *into, NSString *each) { return [into stringByAppendingString:each]; };
	NSString *original = @"12345∆π¬µ∂🚑👖🐢🎈🔄";
	l3_expect([original red_reduce:@"" usingBlock:append]).to.equal(original);
	
	id (^first)(id, id) = ^(id _, id each) { return [REDReduced reduced:each]; };
	l3_expect([original red_reduce:@"" usingBlock:first]).to.equal([original substringToIndex:1]);
}

@end


@implementation NSAttributedString (REDReducible)

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	__block id result = initial;
	[self.string enumerateSubstringsInRange:(NSRange){ .length = self.length } options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
		result = block(result, [self attributedSubstringFromRange:substringRange]);
		*stop = result != [result self];
	}];
	return [result self];
}

l3_test(@selector(red_reduce:usingBlock:)) {
	NSAttributedString *(^append)(NSAttributedString *, NSAttributedString *) = ^(NSAttributedString *into, NSAttributedString *each) {
		NSMutableAttributedString *copy = [into mutableCopy];
		[copy appendAttributedString:each];
		return copy;
	};
	NSDictionary *attributes = @{ @"key": @"value" };
	NSAttributedString *original = [[NSAttributedString alloc] initWithString:@"♬🐡😠" attributes:attributes];
	l3_expect([original red_reduce:[NSAttributedString new] usingBlock:append]).to.equal(original);
	
	id (^first)(id, id) = ^(id _, id each) { return [REDReduced reduced:each]; };
	l3_expect([original red_reduce:@"" usingBlock:first]).to.equal([[NSAttributedString alloc] initWithString:@"♬" attributes:attributes]);
}

@end


@implementation NSEnumerator (REDReducible)

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	id each;
	while ((each = [self nextObject])) {
		initial = block(initial, each);
		if (initial != [initial self]) break;
	}
	return [initial self];
}

l3_test(@selector(red_reduce:usingBlock:)) {
	NSEnumerator *enumerator = [@[ @1, @2, @3 ] reverseObjectEnumerator];
	NSMutableArray *into = [NSMutableArray new];
	NSMutableArray *(^append)(NSMutableArray *, id) = ^(NSMutableArray *into, id each) {
		[into addObject:each];
		return into;
	};
	l3_expect([enumerator red_reduce:into usingBlock:append]).to.equal(@[ @3, @2, @1 ]);
	
	id (^first)(id, id) = ^(id _, id each) { return [REDReduced reduced:each]; };
	l3_expect([[@[ @1, @2, @3 ] reverseObjectEnumerator] red_reduce:nil usingBlock:first]).to.equal(@3);
}

@end


@implementation NSIndexSet (REDReducible)

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	__block id result = initial;
	[self enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
		result = block(initial, @(index));
	}];
	return [result self];
}

@end
