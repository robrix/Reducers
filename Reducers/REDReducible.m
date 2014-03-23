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
	id (^lastObject)(id, id) = ^(id into, id each) { return each; };
	l3_expect(REDStrictReduce(collection, initial, lastObject)).to.equal(collection.lastObject);
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
