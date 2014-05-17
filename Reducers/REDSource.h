//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Reducers/REDIterable.h>
#import <Reducers/REDReducible.h>

@interface REDSource : NSObject <REDIterable, REDReducible>

@property (readonly) id sample;

@end
