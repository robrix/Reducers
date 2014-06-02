//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Reducers/REDReducible.h>

/// A collection or other object which can create new instances by appending onto it.
@protocol REDAppendable <NSObject>

/// Append the objects in \c from onto a copy of the receiver.
///
/// \param from  The reducible to append onto a copy of the receiver.
/// \return      An appendable with the objects in \c from appended onto it. This should be an immutable copy (at least in type), and thus, where applicable, should be typed as the receiving class’ immutable superclass, rather than \c instancetype.
-(instancetype)red_byAppending:(id<REDReducible>)from;

/// Calls \c -red_byAppending: on an empty instance of \c self.
///
/// \param from  The reducible to append onto a new, empty instance of the receiver.
/// \return      A new appendable with the objects in \c from appended onto it.
+(instancetype)red_byAppending:(id<REDReducible>)from;

@end


/// A collection or other object which can be appended onto in place.
@protocol REDMutableAppendable <REDAppendable>

/// Append the objects in \c from onto the receiver.
///
/// \param from  The reducible to append onto the receiver.
/// \return      The receiver.
-(instancetype)red_append:(id<REDReducible>)from;

@end


#pragma mark Categories

/// \c NSArray conforms to \c REDAppendable.
@interface NSArray (REDAppendable) <REDAppendable>

-(NSArray *)red_byAppending:(id<REDReducible>)from;

@end

/// \c NSMutableArray conforms to \c REDMutableAppendable.
@interface NSMutableArray (REDMutableAppendable) <REDMutableAppendable>
@end


/// \c NSSet conforms to \c REDAppendable.
@interface NSSet (REDAppendable) <REDAppendable>

-(NSSet *)red_byAppending:(id<REDReducible>)from;

@end

/// \c NSMutableSet conforms to \c REDMutableAppendable.
@interface NSMutableSet (REDMutableAppendable) <REDMutableAppendable>
@end


/// \c NSOrderedSet conforms to \c REDAppendable.
@interface NSOrderedSet (REDAppendable) <REDAppendable>

-(NSOrderedSet *)red_byAppending:(id<REDReducible>)from;

@end

/// \c NSMutableOrderedSet conforms to \c REDMutableAppendable.
@interface NSMutableOrderedSet (REDMutableAppendable) <REDMutableAppendable>
@end


/// \c NSDictionary conforms to \c REDAppendable.
///
/// The reducible being appended must produce objects conforming to \c REDKeyValuePair, and the pairs’ keys and values must not be nil.
@interface NSDictionary (REDAppendable) <REDAppendable>

-(NSDictionary *)red_byAppending:(id<REDReducible>)from;

@end

/// \c NSMutableDictionary conforms to \c REDMutableAppendable.
///
/// The reducible being appended must produce objects conforming to \c REDKeyValuePair, and the pairs’ keys and values must not be nil.
@interface NSMutableDictionary (REDMutableAppendable) <REDMutableAppendable>
@end


/// \c NSString conforms to \c REDAppendable.
///
/// The reducible being appended will have \c -description called on each of its elements, and those descriptions will be appended onto the receiver.
@interface NSString (REDAppendable) <REDAppendable>

-(NSString *)red_byAppending:(id<REDReducible>)from;

@end

/// \c NSMutableString conforms to \c REDMutableAppendable.
///
/// The reducible being appended will have \c -description called on each of its elements, and those descriptions will be appended onto the receiver.
@interface NSMutableString (REDMutableAppendable) <REDMutableAppendable>
@end


/// \c NSAttributedString conforms to \c REDAppendable.
///
/// The reducible being appended must produce non-nil \c NSAttributedString instances.
@interface NSAttributedString (REDAppendable) <REDAppendable>

-(NSAttributedString *)red_byAppending:(id<REDReducible>)from;

@end

/// \c NSMutableAttributedString conforms to \c REDAppendable.
///
/// The reducible being appended must produce non-nil \c NSAttributedString instances.
@interface NSMutableAttributedString (REDMutableAppendable) <REDMutableAppendable>
@end
