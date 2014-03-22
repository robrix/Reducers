//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Reducers/REDReducible.h>

/// A block which takes a reducing block and returns another reducing block which can be used to apply some transformation to the reduction.
///
/// \param block The reducing block to transform.
///
/// \return A reducing block which applies some transformation to the elements it reduces over.
typedef REDReducingBlock (^REDReducingTransformerBlock)(REDReducingBlock block);


/// A reducible object which applies some transformation to the block it is reduced with.
@interface REDReducer : NSObject <REDReducible>

/// Create a reducer which, when reduced, reduces \c reducible using the result of applying \c transformer to the reducing block passed to it.
///
/// \param reducible The reducible to reduce when the new reducer is reduced. This may be a collection, another reducer, or some other object conforming to \c REDReducible. May not be nil.
/// \param transformer The transforming block which the new reducer will use when reduced. May not be nil.
///
/// \return A new reducer which reduces over \c reducible using reducing blocks transformed by \c transformer.
+(instancetype)reducerWithReducible:(id<REDReducible>)reducible transformer:(REDReducingTransformerBlock)transformer;

@end
