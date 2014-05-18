//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Reducers/REDIterable.h>
#import <Reducers/REDReducible.h>

/// A reducer which interleaves a separator between elements of a collection.
///
/// \param collection The collection to join. Must not be nil.
/// \param separator The element to separate the elements of \c collection with. Must not be nil.
///
/// \c A reducer which, when reduced, produces \c separator between each element of \c collection.
id<REDIterable, REDReducible> REDJoin(id<REDIterable, REDReducible> collection, id separator);
