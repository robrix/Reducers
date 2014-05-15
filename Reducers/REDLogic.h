//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Reducers/REDMap.h>

#pragma mark Logic

/// Performs a logical ‘and’ operation over the elements of a collection.
///
/// Instead of the traditional true/false, this function returns the final element of the \c collection if all elements are not \c nil, or else \c nil. It can therefore be used to chain dependent actions such that later actions are not taken if earlier ones were \c nil.
///
/// \param collection  The collection to take the logical ‘and’ of.
/// \return            The last element of \c collection if no element of \c collection is \c nil, or \c nil otherwise.
id REDAnd(id<REDReducible> collection);


/// Performs a logical ‘or’ operation over the elements of a collection.
///
/// Instead of the traditional true/false, this function returns the first element of the \c collection that is not \c nil. It can therefore be used to chain dependent actions such that earlier actions will take precedence over later ones.
///
/// \param collection  The collection to take the logical ‘or’ of.
/// \return            The first element of \c collection which is not \c nil.
id REDOr(id<REDReducible> collection);
