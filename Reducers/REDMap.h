//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Reducers/REDReducible.h>

/// A unary block for the piecewise mapping of collections.
///
/// \param each The object being mapped. When applied to a collection, the block will typically called once per element, passed in as this argument.
///
/// \return The result of the map. This may or may not end up being appended onto another collection, so use caution when returning \c nil.
typedef id (^REDMapBlock)(id each);


/// The identity map.
///
/// Returns its argument.
extern REDMapBlock const REDIdentityMapBlock;


/// A reducer which applies a map to each element.
///
/// \param collection The collection to map over.
/// \param map The block to map with.
///
/// \return A reducible which, when reduced, maps each element of \c collection using \c map.
id<REDReducible> REDMap(id<REDReducible> collection, REDMapBlock map);
