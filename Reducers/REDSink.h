//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Reducers/REDAppendable.h>

typedef void (^REDSinkBlock)(id);

@interface REDSink : NSObject <REDAppendable>

+(instancetype)sinkWithBlock:(REDSinkBlock)block;

@property (readonly) REDSinkBlock block;

@end
