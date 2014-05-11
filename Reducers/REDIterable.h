//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>

#pragma mark Iterable

/// A nullary block iterating the elements of a collection over successive calls.
///
/// \return The next object in the collection, or nil if it has iterated the entire collection.
typedef id (^REDIteratingBlock)(void);

/// A collection which can be iterated.
@protocol REDIterable <NSObject>

/// An iterator for this collection.
@property (readonly) REDIteratingBlock red_iterator;

@end


#pragma mark Enumerate

/// Call a block once for each object in an \c iterator.
///
/// \param iterator  A \c REDIteratingBlock to enumerate until it returns \c nil.
/// \param block     A block to call once for each object in the \c iterator.
void REDEnumerate(REDIteratingBlock iterator, void(^block)(id each));


#pragma mark Categories

/// \c NSArray conforms to \c REDIterable.
@interface NSArray (REDIterable) <REDIterable>
@end


/// \c NSSet conforms to \c REDIterable.
@interface NSSet (REDIterable) <REDIterable>
@end


/// \c NSOrderedSet conforms to \c REDIterable.
@interface NSOrderedSet (REDIterable) <REDIterable>
@end


/// \c NSDictionary conforms to \c REDIterable.
///
/// Iteration traverses the keys (as with \c NSFastEnumeration).
@interface NSDictionary (REDIterable) <REDIterable>
@end


#pragma mark Iterators

/// Iterate a \c collection using \c NSFastEnumeration.
///
/// \param collection  A fast enumeration to iterate.
/// \return            An iterating block which will produce the objects enumerated in \c collection one by one, until it has exhausted them, at which point it will return \c nil.
REDIteratingBlock REDIteratorWithFastEnumeration(id<NSFastEnumeration> collection);
