//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDMap.h"
#import "REDReducer.h"

REDMapBlock const REDIdentityMapBlock = ^(id x) {
	return x;
};

l3_test(REDIdentityMapBlock) {
	id specific = [NSObject new];
	l3_expect(REDIdentityMapBlock(specific)).to.equal(specific);
}


id<REDReducible> REDMap(id<REDReducible> collection, REDMapBlock map) {
	return [REDReducer reducerWithReducible:collection transformer:^(REDReducingBlock reduce) {
		// Transform by mapping each object.
		return ^(id into, id each) {
			return reduce(into, map(each));
		};
	}];
}

l3_addTestSubjectTypeWithFunction(REDMap)
l3_test(&REDMap) {
	id<REDReducible> collection = @[ @"a", @"b", @"c" ];
	REDReducingBlock append = ^(NSMutableArray *into, id each) {
		[into addObject:each];
		return into;
	};
	NSMutableArray *into = [NSMutableArray new];
	l3_expect([REDMap(collection, REDIdentityMapBlock) red_reduce:into usingBlock:append]).to.equal(collection);
	
	__block NSInteger effects = 0;
	REDMapBlock withEffects = ^(id each) {
		++effects;
		return [each stringByAppendingString:each];
	};
	l3_expect(REDMap(collection, withEffects)).not.to.equal(nil);
	l3_expect(effects).to.equal(@0);
	
	into = [NSMutableArray new];
	NSArray *transformed = @[@"aa", @"bb", @"cc"];
	l3_expect([REDMap(collection, withEffects) red_reduce:into usingBlock:append]).to.equal(transformed);
	l3_expect(effects).to.equal(@3);
}
