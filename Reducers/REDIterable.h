//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>

/// A nullary block iterating the elements of a collection over successive calls.
///
/// \return The next object in the collection, or nil if it has iterated the entire collection.
typedef id (^REDIteratingBlock)(void);

/// A collection which can be iterated.
@protocol REDIterable <NSObject>

/// An iterator for this collection.
@property (readonly) REDIteratingBlock red_iterator;

@end


#pragma mark Conveniences

/// Iterate a \c collection using \c NSFastEnumeration.
///
/// \param collection  A fast enumeration to iterate.
/// \return            An iterating block which will produce the objects enumerated in \c collection one by one, until it has exhausted them, at which point it will return \c nil.
REDIteratingBlock REDIteratorWithFastEnumeration(id<NSFastEnumeration> collection);
