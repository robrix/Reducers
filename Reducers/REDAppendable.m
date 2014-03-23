//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDAppendable.h"

#pragma mark Categories

@implementation NSArray (REDAppendable)

-(instancetype)red_append:(id<REDReducible>)from {
	return [[self mutableCopy] red_append:from];
}

@end

@implementation NSMutableArray (REDAppendable)

static NSMutableArray *(^const REDMutableArrayAppend)(NSMutableArray *into, id each) = ^(NSMutableArray *into, id each){
	[into addObject:each];
	return into;
};

-(instancetype)red_append:(id<REDReducible>)from {
	return [from red_reduce:self usingBlock:REDMutableArrayAppend];
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

-(instancetype)red_append:(id<REDReducible>)from {
	return [[self mutableCopy] red_append:from];
}

@end

@implementation NSMutableSet (REDAppendable)

static NSMutableSet *(^const REDMutableSetAppend)(NSMutableSet *into, id each) = ^(NSMutableSet *into, id each){
	[into addObject:each];
	return into;
};

-(instancetype)red_append:(id<REDReducible>)from {
	return [from red_reduce:self usingBlock:REDMutableSetAppend];
}

l3_test(@selector(red_append:)) {
	NSSet *empty = [NSSet set];
	NSSet *anything = [NSSet setWithObjects:@"a", @"b", nil];
	l3_expect([empty red_append:anything]).to.equal(anything);
	NSArray *array = @[ @"c" ];
	l3_expect([empty red_append:array]).to.equal([NSSet setWithArray:array]);
	l3_expect([anything red_append:array]).to.equal([anything setByAddingObjectsFromArray:array]);
	
	NSMutableSet *initiallyEmptyMutableSet = [empty mutableCopy];
	l3_expect([initiallyEmptyMutableSet red_append:anything]).to.equal(anything);
	l3_expect(initiallyEmptyMutableSet).to.equal(anything);
}

@end
