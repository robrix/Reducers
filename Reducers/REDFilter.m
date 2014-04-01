//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDFilter.h"
#import "REDReducer.h"

#pragma mark Filter

id<REDReducible> REDFilter(id<REDReducible> collection, REDPredicateBlock predicate) {
	return [REDReducer reducerWithReducible:collection transformer:^REDReducingBlock(REDReducingBlock reduce) {
		// Reduce only those elements which match the predicate.
		return ^(id into, id each) {
			return predicate(each)?
				reduce(into, each)
			:	into;
		};
	}];
}

l3_addTestSubjectTypeWithFunction(REDFilter)
l3_test(&REDFilter) {
	id collection = @[ @"aardvarks", @"fish", @"penguins", @"sheep", @"moose" ];
	id filtered = @[ @"aardvarks", @"penguins" ];
	REDPredicateBlock predicate = ^bool (NSString *subject) { return [subject hasSuffix:@"s"]; };
	NSArray *into = @[];
	REDReducingBlock append = ^(NSArray *into, id each) { return [into arrayByAddingObject:each]; };
	l3_expect([REDFilter(collection, predicate) red_reduce:into usingBlock:append]).to.equal(filtered);
}


#pragma mark Predicates

REDPredicateBlock const REDTruePredicateBlock = ^bool (id _) {
	return true;
};

REDPredicateBlock const REDFalsePredicateBlock = ^bool (id _) {
	return false;
};


REDPredicateBlock REDEqualityPredicate(id object) {
	return ^bool (id subject) {
		return [subject isEqual:object];
	};
}

l3_addTestSubjectTypeWithFunction(REDEqualityPredicate)
l3_test(&REDEqualityPredicate) {
	id original = @"x";
	id copy = [original mutableCopy];
	l3_expect(copy == original).to.equal(@NO);
	l3_expect(REDEqualityPredicate(original)(copy)).to.equal(@YES);
}


REDPredicateBlock REDIdentityPredicate(id object) {
	return ^bool (id subject) {
		return subject == object;
	};
}

l3_test(&REDIdentityPredicate) {
	id original = @"x";
	id copy = [original mutableCopy];
	id same = original;
	l3_expect(REDIdentityPredicate(original)(copy)).to.equal(@NO);
	l3_expect(REDIdentityPredicate(original)(same)).to.equal(@YES);
}


REDPredicateBlock REDNotPredicate(REDPredicateBlock predicate) {
	return ^bool (id subject) {
		return !predicate(subject);
	};
}

l3_addTestSubjectTypeWithFunction(REDNotPredicate)
l3_test(&REDNotPredicate) {
	id anything = [NSObject new];
	l3_expect(REDNotPredicate(REDTruePredicateBlock)(anything)).to.equal(@NO);
	l3_expect(REDNotPredicate(REDFalsePredicateBlock)(anything)).to.equal(@YES);
}
