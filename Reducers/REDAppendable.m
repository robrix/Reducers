//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDAppendable.h"
#import "REDPair.h"

#pragma mark REDAppendable categories

@implementation NSArray (REDAppendable)

-(NSArray *)red_byAppending:(id<REDReducible>)from {
	return [[self mutableCopy] red_append:from];
}

l3_test(@selector(red_byAppending:)) {
	NSArray *empty = @[];
	NSArray *anything = @[ @"a", @"b" ];
	l3_expect([empty red_byAppending:anything]).to.equal(anything);
	NSSet *set = [NSSet setWithObject:@"c"];
	l3_expect([empty red_byAppending:set]).to.equal(set.allObjects);
	l3_expect([anything red_byAppending:set]).to.equal([anything arrayByAddingObjectsFromArray:set.allObjects]);
}


+(NSArray *)red_byAppending:(id<REDReducible>)from {
	return [[NSMutableArray new] red_append:from];
}

@end


@implementation NSSet (REDAppendable)

-(NSSet *)red_byAppending:(id<REDReducible>)from {
	return [[self mutableCopy] red_append:from];
}

l3_test(@selector(red_byAppending:)) {
	NSSet *empty = [NSSet set];
	NSSet *anything = [NSSet setWithObjects:@"a", @"b", nil];
	l3_expect([empty red_byAppending:anything]).to.equal(anything);
	NSArray *array = @[ @"c" ];
	l3_expect([empty red_byAppending:array]).to.equal([NSSet setWithArray:array]);
	l3_expect([anything red_byAppending:array]).to.equal([anything setByAddingObjectsFromArray:array]);
}


+(NSSet *)red_byAppending:(id<REDReducible>)from {
	return [[NSMutableSet new] red_append:from];
}

@end


@implementation NSOrderedSet (REDAppendable)

-(NSOrderedSet *)red_byAppending:(id<REDReducible>)from {
	return [[self mutableCopy] red_append:from];
}

l3_test(@selector(red_byAppending:)) {
	NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithObjects:@0, @1, @2, nil];
	NSArray *intersecting = @[ @2, @0, @1, @3, @4, @5 ];
	NSMutableOrderedSet *unionOrderedSet = [orderedSet mutableCopy];
	[unionOrderedSet addObjectsFromArray:intersecting];
	l3_expect([orderedSet red_byAppending:intersecting]).to.equal(unionOrderedSet);
}


+(NSOrderedSet *)red_byAppending:(id<REDReducible>)from {
	return [[NSMutableOrderedSet new] red_append:from];
}

@end


@implementation NSDictionary (REDAppendable)

-(NSDictionary *)red_byAppending:(id<REDReducible>)from {
	return [[self mutableCopy] red_append:from];
}

l3_test(@selector(red_byAppending:)) {
	NSArray *pairs = @[ @[ @"key", @"value" ], @[ @"number", @3 ], @[ @"number", @4 ], ];
	NSDictionary *expected = @{ @"key": @"value", @"number": @4, };
	NSDictionary *empty = @{};
	l3_expect([empty red_byAppending:pairs]).to.equal(expected);
}


+(NSDictionary *)red_byAppending:(id<REDReducible>)from {
	return [[NSMutableDictionary new] red_append:from];
}

@end


@implementation NSString (REDAppendable)

-(NSString *)red_byAppending:(id<REDReducible>)from {
	return [[self mutableCopy] red_append:from];
}

l3_test(@selector(red_byAppending:)) {
	NSArray *collection = @[ @1, @2, @3 ];
	NSString *anything = @"prefix";
	NSString *empty = @"";
	l3_expect([empty red_byAppending:collection]).to.equal(@"123");
	l3_expect([anything red_byAppending:collection]).to.equal(@"prefix123");
}


+(NSString *)red_byAppending:(id<REDReducible>)from {
	return [[NSMutableString new] red_append:from];
}

@end


@implementation NSAttributedString (REDAppendable)

-(NSAttributedString *)red_byAppending:(id<REDReducible>)from {
	return [[self mutableCopy] red_append:from];
}

l3_test(@selector(red_byAppending:)) {
	NSDictionary *attributes = @{ @"key": @"value" };
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"v" attributes:attributes];
	NSAttributedString *empty = [NSAttributedString new];
	NSAttributedString *joined = [[NSAttributedString alloc] initWithString:@"vvv" attributes:attributes];
	id<REDReducible> all = @[ attributedString, attributedString, attributedString ];
	l3_expect([empty red_byAppending:all]).to.equal(joined);
}


+(NSAttributedString *)red_byAppending:(id<REDReducible>)from {
	return [[NSMutableAttributedString new] red_append:from];
}

@end


@implementation NSIndexSet (REDAppendable)

-(instancetype)red_byAppending:(id<REDReducible>)from {
	return [[self mutableCopy] red_append:from];
}

+(instancetype)red_byAppending:(id<REDReducible>)from {
	return [[NSMutableIndexSet new] red_append:from];
}

@end


#pragma mark REDMutableAppendable categories

@implementation NSMutableArray (REDMutableAppendable)

static NSMutableArray *(^const REDMutableArrayAppend)(NSMutableArray *, id) = ^(NSMutableArray *into, id each) {
	[into addObject:each];
	return into;
};

-(instancetype)red_append:(id<REDReducible>)from {
	return [from red_reduce:self usingBlock:REDMutableArrayAppend];
}

@end


@implementation NSMutableSet (REDMutableAppendable)

static NSMutableSet *(^const REDMutableSetAppend)(NSMutableSet *, id) = ^(NSMutableSet *into, id each) {
	[into addObject:each];
	return into;
};

-(instancetype)red_append:(id<REDReducible>)from {
	return [from red_reduce:self usingBlock:REDMutableSetAppend];
}

@end


@implementation NSMutableOrderedSet (REDMutableAppendable)

static NSMutableOrderedSet *(^const REDMutableOrderedSetAppend)(NSMutableOrderedSet *, id) = ^(NSMutableOrderedSet *into, id each) {
	[into addObject:each];
	return into;
};

-(instancetype)red_append:(id<REDReducible>)from {
	return [from red_reduce:self usingBlock:REDMutableOrderedSetAppend];
}

@end


@implementation NSMutableDictionary (REDMutableAppendable)

static NSMutableDictionary *(^const REDMutableDictionaryAppend)(NSMutableDictionary *, id) = ^(NSMutableDictionary *into, id<REDKeyValuePair> each) {
	[into setObject:each.red_value forKey:each.red_key];
	return into;
};

-(instancetype)red_append:(id<REDReducible>)from {
	return [from red_reduce:self usingBlock:REDMutableDictionaryAppend];
}

@end


@implementation NSMutableString (REDMutableAppendable)

static NSMutableString *(^const REDMutableStringAppend)(NSMutableString *, id) = ^(NSMutableString *into, id each) {
	[into appendString:[each description]];
	return into;
};

-(instancetype)red_append:(id<REDReducible>)from {
	return [from red_reduce:self usingBlock:REDMutableStringAppend];
}

@end


@implementation NSMutableAttributedString (REDMutableAppendable)

static NSMutableAttributedString *(^const REDMutableAttributedStringAppend)(NSMutableAttributedString *, NSAttributedString *) = ^(NSMutableAttributedString *into, NSAttributedString *each) {
	[into appendAttributedString:each];
	return into;
};

-(instancetype)red_append:(id<REDReducible>)from {
	return [from red_reduce:self usingBlock:REDMutableAttributedStringAppend];
}

@end


@implementation NSMutableIndexSet (REDMutableAppendable)

static NSMutableIndexSet *(^const REDMutableIndexSetAppend)(NSMutableIndexSet *, NSNumber *) = ^(NSMutableIndexSet *into, NSNumber *each) {
	[into addIndex:each.unsignedIntegerValue];
	return into;
};

-(instancetype)red_append:(id<REDReducible>)from {
	return [from red_reduce:self usingBlock:REDMutableIndexSetAppend];
}

@end
