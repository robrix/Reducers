//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "REDConvolve.h"
#import "REDFilter.h"
#import "REDMap.h"
#import "REDSource.h"

@interface NSObject (REDObject)

-(instancetype)red_object;

@end


@implementation REDSource

#pragma mark REDIterable

-(REDIteratingBlock)red_iterator {
	return ^{
		return self.sample;
	};
}

/*
 
 - notify when updated
 - maps, flatten maps, filters, convolutions, joins, etc, are lazy
	- only applied once reduced
	- reducers pass notifications along
		- filters omit notifications for filtered items
		- flatten maps & joins multiply notifications for produced items
		- convolutions coalesce notifications from each iterable into a single notification
 - -red_reduce:usingBlock: forces
 - -red_reduce:usingBlock: returns an observer of the ongoing reduction, which can be used to cancel it
 
 - KVO source
 - KVO diff source
 - notification source
 
 - latch source
 
 */

#pragma mark REDReducible

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	__block id into = initial;
	REDEnumerate(self.red_iterator, ^(id each, bool *stop) {
		into = block(into, each);
		*stop = into != [into self];
	});
	return [into self];
}

// source with no observers does not evaluate
// source with an observer evaluates
// source with an observer evaluates every time it is updated

@end


@interface REDObserver : NSObject

@property (readonly) id target;
@property (readonly) NSString *keyPath;
@property (readonly) id initial;
@property (readonly) REDReducingBlock block;

@end

@implementation REDObserver

+(instancetype)observerWithTarget:(id)target keyPath:(NSString *)keyPath initial:(id)initial block:(REDReducingBlock)block {
	return [[self alloc] initWithTarget:target keyPath:keyPath initial:initial block:block];
}

-(instancetype)initWithTarget:(id)target keyPath:(NSString *)keyPath initial:(id)initial block:(REDReducingBlock)block {
	NSParameterAssert(target != nil);
	NSParameterAssert(keyPath != nil);
	NSParameterAssert(block != nil);
	
	if ((self = [super init])) {
		_target = target;
		_keyPath = [keyPath copy];
		_initial = initial;
		_block = [block copy];
		
		[self startObserving];
	}
	return self;
}


static void * const REDObserverContext = (void *)&REDObserverContext;

-(void)startObserving {
	[self.target addObserver:self forKeyPath:self.keyPath options:NSKeyValueObservingOptionPrior | NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:REDObserverContext];
}

-(void)stopObserving {
	[self.target removeObserver:self forKeyPath:self.keyPath context:REDObserverContext];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (context == REDObserverContext) {
		if (change[NSKeyValueChangeNotificationIsPriorKey]) {
//			_prior =
		} else {
			_initial = self.block(self.initial, [change[NSKeyValueChangeNewKey] red_object]);
		}
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

@end


@interface REDLatch : NSObject <REDIterable, REDReducible>

@property id sample;

@end

@implementation REDLatch

#pragma mark REDIterable

-(REDIteratingBlock)red_iterator {
	return ^{
		return [REDObserver observerWithTarget:self keyPath:@"sample" initial:nil block:^(id into, id each) { return each; }];
	};
}


#pragma mark REDReducible

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	return [REDObserver observerWithTarget:self keyPath:@"sample" initial:initial block:block];
}

l3_test(@selector(red_reduce:usingBlock:)) {
	REDLatch *a = [REDLatch new];
	REDLatch *b = [REDLatch new];
	
	id<REDReducible> left = REDMap(REDFilter(a, ^bool (NSString *each) { return ![each hasPrefix:@"b"]; }), ^(id each) { return [each stringByAppendingString:each]; });
	id<REDReducible> right = b;
	
	__block id current;
	__block NSUInteger effects = 0;
	
	id<REDReducible> reducible = REDConvolve(@[ left, right ], ^(NSString *a, NSString *b) { return [a stringByAppendingString:b ?: @""]; });
	
	REDObserver *observer = [reducible red_reduce:current usingBlock:^(id into, id each) {
		effects += 1;
		return current = each;
	}];
	
	l3_expect(current).to.equal(nil);
	l3_expect(effects).to.equal(@1);
	
	a.sample = @"";
	l3_expect(current).to.equal(@"");
	l3_expect(effects).to.equal(@2);
	
	a.sample = @"because";
	l3_expect(current).to.equal(@"");
	l3_expect(effects).to.equal(@2);
	
	a.sample = @"a";
	l3_expect(current).to.equal(@"aa");
	l3_expect(effects).to.equal(@3);
	
	a.sample = @"b";
	l3_expect(current).to.equal(@"aa");
	l3_expect(effects).to.equal(@3);
	
	a.sample = @"c";
	l3_expect(current).to.equal(@"cc");
	l3_expect(effects).to.equal(@4);
	
	b.sample = @"d";
	l3_expect(current).to.equal(@"ccd");
	l3_expect(effects).to.equal(@5);
	
	[observer stopObserving];
}

@end


@implementation NSObject (REDObject)

-(instancetype)red_object {
	return self;
}

@end

@implementation NSNull (REDObject)

-(instancetype)red_object {
	return nil;
}

@end
