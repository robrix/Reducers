//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Reducers/REDReducible.h>

#pragma mark Map

/// A unary block for the piecewise mapping of collections.
///
/// \param each The object being mapped. When applied to a collection, the block will typically called once per element, passed in as this argument.
///
/// \return The result of the map applied to \c each. This may or may not end up being appended onto another collection, so use caution when returning \c nil.
typedef id (^REDMapBlock)(id each);


/// A reducer which applies a map to each element.
///
/// \param collection The collection to map over. Must not be nil.
/// \param map The block to map with. Must not be nil.
///
/// \return A reducible which, when reduced, maps each element of \c collection using \c map.
id<REDReducible> REDMap(id<REDReducible> collection, REDMapBlock map);


#pragma mark Flatten map

/// A unary block for the piecewise mapping and concatenating of collections.
///
/// \param each The object being mapped. Flattening is applied after mapping, so the arguments passed here will be the branches, not the leaves, if applicable.
///
/// \return The result of the map applied to \c each. This must return a reducible, regardless of whether \c each is itself reducible.
typedef id<REDReducible> (^REDFlattenMapBlock)(id each);


/// A reducer which applies a map to each reducible element, and flattens the results.
///
/// \param collection The collection to map over. Must not be nil.
/// \param map The block to map with. Note that this must return a result conforming to the \c REDReducible protocol so that it can be concatenated. Must not be nil.
///
/// \return A reducible which, when reduced, concatenates the results of mapping each element of \c collection using \c map.
id<REDReducible> REDFlattenMap(id<REDReducible> collection, REDFlattenMapBlock map);


#pragma mark Identity

/// The identity map.
///
/// Returns its argument.
extern REDMapBlock const REDIdentityMapBlock;
