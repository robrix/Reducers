//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Reducers/REDReducible.h>

#pragma mark Logic

/// Performs a logical ‘and’ operation over the elements of a collection.
///
/// Instead of the traditional true/false, this function returns the final element of the \c collection if all elements are not \c nil, or else \c nil. It can therefore be used to chain dependent actions.
///
/// \param collection  The collection to take the logical and of.
/// \return            The last element of \c collection if no element of \c collection is \c nil, or \c nil otherwise.
id REDAnd(id<REDReducible> collection);
