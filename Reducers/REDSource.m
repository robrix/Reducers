//  Copyright (c) 2014 Rob Rix. All rights reserved.

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


#pragma mark REDReducible

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	__block id into = initial;
	REDEnumerate(self.red_iterator, ^(id each, bool *stop) {
		into = block(into, each);
		*stop = into != [into self];
	});
	return [into self];
}

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
