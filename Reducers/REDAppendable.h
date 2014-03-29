//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Reducers/REDReducible.h>

/// A collection or other object which can be appended onto.
@protocol REDAppendable <NSObject>

/// Append the objects in \c from onto \c self.
///
/// \param from The reducible to append onto \c self.
///
/// \return An appendable with the objects in \c from appended onto it. For mutable collections, this should be \c self, while for immutable ones it should be a copy.
-(instancetype)red_append:(id<REDReducible>)from;

@end


#pragma mark Categories

/// \c NSArray conforms to \c REDAppendable.
@interface NSArray (REDAppendable) <REDAppendable>
@end


/// \c NSSet conforms to \c REDAppendable.
@interface NSSet (REDAppendable) <REDAppendable>
@end


/// \c NSDictionary conforms to \c REDAppendable.
///
/// The reducible being appended must produce objects conforming to \c REDKeyValuePair, and the pairs’ keys and values must not be nil.
@interface NSDictionary (REDAppendable) <REDAppendable>
@end


/// \c NSString conforms to \c REDAppendable.
///
/// The reducible being appended will have \c -description called on each of its elements, and those descriptions will be appended onto the receiver.
@interface NSString (REDAppendable) <REDAppendable>
@end


/// \c NSAttributedString conforms to \c REDAppendable.
@interface NSAttributedString (REDAppendable) <REDAppendable>
@end

