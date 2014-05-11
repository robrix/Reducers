//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>

@protocol REDIterable <NSObject>

@property (readonly) id(^red_iterator)(void);

@end
