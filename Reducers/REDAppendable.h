//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Reducers/REDReducible.h>

/// A collection or other object which can create new instances by appending onto it.
@protocol REDAppendable <NSObject>

/// Append the objects in \c from onto the receiver.
///
/// \param from  The reducible to append onto the receiver.
/// \return      An appendable with the objects in \c from appended onto it. This should generally be a (presumably immutable) copy, and thus, where applicable, should be typed as the receiving class’ immutable superclass, rather than \c instancetype.
-(instancetype)red_byAppending:(id<REDReducible>)from;

/// Calls \c -red_byAppending: on an empty instance of \c self.
///
/// \param from  The reducible to append onto a new, empty instance of the receiver.
/// \return      A new appendable with the objects in \c from appended onto it.
+(instancetype)red_byAppending:(id<REDReducible>)from;

@end


#pragma mark Categories

/// \c NSArray conforms to \c REDAppendable.
@interface NSArray (REDAppendable) <REDAppendable>

-(NSArray *)red_byAppending:(id<REDReducible>)from;

@end


/// \c NSSet conforms to \c REDAppendable.
@interface NSSet (REDAppendable) <REDAppendable>

-(NSSet *)red_byAppending:(id<REDReducible>)from;

@end


/// \c NSOrderedSet conforms to \c REDAppendable.
@interface NSOrderedSet (REDAppendable) <REDAppendable>

-(NSOrderedSet *)red_byAppending:(id<REDReducible>)from;

@end


/// \c NSDictionary conforms to \c REDAppendable.
///
/// The reducible being appended must produce objects conforming to \c REDKeyValuePair, and the pairs’ keys and values must not be nil.
@interface NSDictionary (REDAppendable) <REDAppendable>

-(NSDictionary *)red_byAppending:(id<REDReducible>)from;

@end


/// \c NSString conforms to \c REDAppendable.
///
/// The reducible being appended will have \c -description called on each of its elements, and those descriptions will be appended onto the receiver.
@interface NSString (REDAppendable) <REDAppendable>

-(NSString *)red_byAppending:(id<REDReducible>)from;

@end


/// \c NSAttributedString conforms to \c REDAppendable.
@interface NSAttributedString (REDAppendable) <REDAppendable>

-(NSAttributedString *)red_byAppending:(id<REDReducible>)from;

@end

