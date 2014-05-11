//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Reducers/REDReducible.h>

#pragma mark Convolve

/// A block for the piecewise mapping of multiple collections (convolution).
///
/// Although this is not declared with any parameters, it will actually receive one per iterable passed to \c REDConvolve.
///
/// \return  The object to be produced at each step of the convolution.
typedef id(^REDConvolutionBlock)();


/// A reducer which applies a convolution to each element of each of a collection of iterables.
///
/// \param iterables    A reducible of the iterables to convolve.
/// \param convolution  A block to be applied to each element of the reducibles in turn.
/// \return             A reducible which, when reduced, maps the elements of the reducibles produced by \c reducibles with \c convolution.
id<REDReducible> REDConvolve(id<REDReducible> iterables, REDConvolutionBlock convolution);
