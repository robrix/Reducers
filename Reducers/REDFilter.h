//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Reducers/REDReducible.h>

#pragma mark Filter

/// A block which specifies a predicate over an object.
///
/// \param subject The object to be predicated upon.
///
/// \return \c true if the object passes, \c false if it fails.
typedef bool (^REDPredicateBlock)(id subject);


/// A reducer which filters a reducible.
///
/// \param collection The collection to filter.
/// \param predicate The predicate to apply to each element.
///
/// \return A reducible which, when reduced, produces the elements of \c collection which are matched by \c predicate.
id<REDReducible> REDFilter(id<REDReducible> collection, REDPredicateBlock predicate);


#pragma mark Linear search

/// Searches a reducible, returning the first object which matches a predicate.
///
/// \param collection  The collection to search.
/// \param predicate   The predicate to apply to each element.
/// \return            The first element of \c collection which matches \c predicate, or nil if no elements match.
id REDLinearSearch(id<REDReducible> collection, REDPredicateBlock predicate);


#pragma mark Predicates

/// A predicate which returns \c true.
extern REDPredicateBlock const REDTruePredicateBlock;

/// A predicate which returns \c false.
extern REDPredicateBlock const REDFalsePredicateBlock;


/// Returns a predicate which accepts objects equal to \c object.
///
/// \param object The object to compare against. May be nil.
///
/// \return \c true iff the subject and object are equal as determined by \c -isEqual:.
REDPredicateBlock REDEqualityPredicate(id object);

/// Returns a predicate which accepts objects identical to \c object.
///
/// \param object The object to compare against. May be nil.
///
/// \return \c true iff the subject and object are identical as determined by pointer equality.
REDPredicateBlock REDIdentityPredicate(id object);


/// Returns a predicate which inverts the sense of \c predicate.
///
/// \param predicate The predicate to apply and invert the sense of. Must not be nil.
///
/// \return \c true iff \c predicate returns \c false.
REDPredicateBlock REDNotPredicate(REDPredicateBlock predicate);
