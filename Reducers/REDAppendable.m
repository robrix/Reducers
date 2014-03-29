//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDAppendable.h"
#import "REDPair.h"

#pragma mark Categories

@implementation NSArray (REDAppendable)

static NSMutableArray *(^const REDMutableArrayAppend)(NSMutableArray *, id) = ^(NSMutableArray *into, id each) {
	[into addObject:each];
	return into;
};

-(instancetype)red_append:(id<REDReducible>)from {
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

@end


@implementation NSSet (REDAppendable)

static NSMutableSet *(^const REDMutableSetAppend)(NSMutableSet *, id) = ^(NSMutableSet *into, id each) {
	[into addObject:each];
	return into;
};

-(instancetype)red_append:(id<REDReducible>)from {
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

@end


@implementation NSDictionary (REDAppendable)

static NSMutableDictionary *(^const REDMutableDictionaryAppend)(NSMutableDictionary *, id) = ^(NSMutableDictionary *into, id<REDKeyValuePair> each) {
	[into setObject:each.red_value forKey:each.red_key];
	return into;
};

-(instancetype)red_append:(id<REDReducible>)from {
	return [from red_reduce:[self mutableCopy] usingBlock:REDMutableDictionaryAppend];
}

l3_test(@selector(red_append:)) {
	NSArray *pairs = @[ @[ @"key", @"value" ], @[ @"number", @3 ], @[ @"number", @4 ], ];
	NSDictionary *expected = @{ @"key": @"value", @"number": @4, };
	NSDictionary *empty = @{};
	l3_expect([empty red_append:pairs]).to.equal(expected);
}

@end


@implementation NSString (REDAppendable)

static NSMutableString *(^const REDMutableStringAppend)(NSMutableString *, id) = ^(NSMutableString *into, id each) {
	[into appendString:[each description]];
	return into;
};

-(instancetype)red_append:(id<REDReducible>)from {
	return [from red_reduce:[self mutableCopy] usingBlock:REDMutableStringAppend];
}

l3_test(@selector(red_append:)) {
	NSArray *collection = @[ @1, @2, @3 ];
	NSString *anything = @"prefix";
	NSString *empty = @"";
	l3_expect([empty red_append:collection]).to.equal(@"123");
	l3_expect([anything red_append:collection]).to.equal(@"prefix123");
}

@end


@implementation NSAttributedString (REDAppendable)

static NSMutableAttributedString *(^const REDMutableAttributedStringAppend)(NSMutableAttributedString *, NSAttributedString *) = ^(NSMutableAttributedString *into, NSAttributedString *each) {
	[into appendAttributedString:each];
	return into;
};

-(instancetype)red_append:(id<REDReducible>)from {
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

@end
