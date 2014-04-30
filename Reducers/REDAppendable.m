//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDAppendable.h"
#import "REDPair.h"

@implementation NSArray (REDAppendable)

static NSMutableArray *(^const REDMutableArrayAppend)(NSMutableArray *, id) = ^(NSMutableArray *into, id each) {
	[into addObject:each];
	return into;
};

-(NSArray *)red_append:(id<REDReducible>)from {
	return [from red_reduce:[self mutableCopy] usingBlock:REDMutableArrayAppend];
}

l3_test(@selector(red_append:)) {
	NSArray *empty = @[];
	NSArray *anything = @[ @"a", @"b" ];
	l3_expect([empty red_append:anything]).to.equal(anything);
	NSSet *set = [NSSet setWithObject:@"c"];
	l3_expect([empty red_append:set]).to.equal(set.allObjects);
	l3_expect([anything red_append:set]).to.equal([anything arrayByAddingObjectsFromArray:set.allObjects]);
}


+(NSArray *)red_append:(id<REDReducible>)from {
	return [[self new] red_append:from];
}

@end


@implementation NSSet (REDAppendable)

static NSMutableSet *(^const REDMutableSetAppend)(NSMutableSet *, id) = ^(NSMutableSet *into, id each) {
	[into addObject:each];
	return into;
};

-(NSSet *)red_append:(id<REDReducible>)from {
	return [from red_reduce:[self mutableCopy] usingBlock:REDMutableSetAppend];
}

l3_test(@selector(red_append:)) {
	NSSet *empty = [NSSet set];
	NSSet *anything = [NSSet setWithObjects:@"a", @"b", nil];
	l3_expect([empty red_append:anything]).to.equal(anything);
	NSArray *array = @[ @"c" ];
	l3_expect([empty red_append:array]).to.equal([NSSet setWithArray:array]);
	l3_expect([anything red_append:array]).to.equal([anything setByAddingObjectsFromArray:array]);
}


+(NSSet *)red_append:(id<REDReducible>)from {
	return [[self new] red_append:from];
}

@end


@implementation NSOrderedSet (REDAppendable)

static NSMutableOrderedSet *(^const REDMutableOrderedSetAppend)(NSMutableOrderedSet *, id) = ^(NSMutableOrderedSet *into, id each) {
	[into addObject:each];
	return into;
};

-(NSOrderedSet *)red_append:(id<REDReducible>)from {
	return [from red_reduce:[self mutableCopy] usingBlock:REDMutableOrderedSetAppend];
}

l3_test(@selector(red_append:)) {
	NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithObjects:@0, @1, @2, nil];
	NSArray *intersecting = @[ @2, @0, @1, @3, @4, @5 ];
	NSMutableOrderedSet *unionOrderedSet = [orderedSet mutableCopy];
	[unionOrderedSet addObjectsFromArray:intersecting];
	l3_expect([orderedSet red_append:intersecting]).to.equal(unionOrderedSet);
}


+(NSOrderedSet *)red_append:(id<REDReducible>)from {
	return [[self new] red_append:from];
}

@end


@implementation NSDictionary (REDAppendable)

static NSMutableDictionary *(^const REDMutableDictionaryAppend)(NSMutableDictionary *, id) = ^(NSMutableDictionary *into, id<REDKeyValuePair> each) {
	[into setObject:each.red_value forKey:each.red_key];
	return into;
};

-(NSDictionary *)red_append:(id<REDReducible>)from {
	return [from red_reduce:[self mutableCopy] usingBlock:REDMutableDictionaryAppend];
}

l3_test(@selector(red_append:)) {
	NSArray *pairs = @[ @[ @"key", @"value" ], @[ @"number", @3 ], @[ @"number", @4 ], ];
	NSDictionary *expected = @{ @"key": @"value", @"number": @4, };
	NSDictionary *empty = @{};
	l3_expect([empty red_append:pairs]).to.equal(expected);
}


+(NSDictionary *)red_append:(id<REDReducible>)from {
	return [[self new] red_append:from];
}

@end


@implementation NSString (REDAppendable)

static NSMutableString *(^const REDMutableStringAppend)(NSMutableString *, id) = ^(NSMutableString *into, id each) {
	[into appendString:[each description]];
	return into;
};

-(NSString *)red_append:(id<REDReducible>)from {
	return [from red_reduce:[self mutableCopy] usingBlock:REDMutableStringAppend];
}

l3_test(@selector(red_append:)) {
	NSArray *collection = @[ @1, @2, @3 ];
	NSString *anything = @"prefix";
	NSString *empty = @"";
	l3_expect([empty red_append:collection]).to.equal(@"123");
	l3_expect([anything red_append:collection]).to.equal(@"prefix123");
}


+(NSString *)red_append:(id<REDReducible>)from {
	return [[self new] red_append:from];
}

@end


@implementation NSAttributedString (REDAppendable)

static NSMutableAttributedString *(^const REDMutableAttributedStringAppend)(NSMutableAttributedString *, NSAttributedString *) = ^(NSMutableAttributedString *into, NSAttributedString *each) {
	[into appendAttributedString:each];
	return into;
};

-(NSAttributedString *)red_append:(id<REDReducible>)from {
	return [from red_reduce:[self mutableCopy] usingBlock:REDMutableAttributedStringAppend];
}

l3_test(@selector(red_append:)) {
	NSDictionary *attributes = @{ @"key": @"value" };
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"v" attributes:attributes];
	NSAttributedString *empty = [NSAttributedString new];
	NSAttributedString *joined = [[NSAttributedString alloc] initWithString:@"vvv" attributes:attributes];
	id<REDReducible> all = @[ attributedString, attributedString, attributedString ];
	l3_expect([empty red_append:all]).to.equal(joined);
}


+(NSAttributedString *)red_append:(id<REDReducible>)from {
	return [[self new] red_append:from];
}

@end
