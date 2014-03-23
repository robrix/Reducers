//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>

/// A key-value pair.
@protocol REDKeyValuePair <NSObject>

/// The key.
///
/// Must conform to \c NSCopying. Must not be nil.
@property (readonly) id<NSCopying> red_key;

/// The value.
///
/// Must not be nil.
@property (readonly) id red_value;

@end


#pragma mark Categories

/// \c NSArray conforms to \c REDKeyValuePair.
///
/// \c firstObject is assumed to be the key, and \c lastObject is assumed to be the value.
@interface NSArray (REDKeyValuePair) <REDKeyValuePair>
@end
