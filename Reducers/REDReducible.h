//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>

/// A binary block defining some piecewise reduction of a collection.
///
/// \param into The result of the previous step of the reduction.
/// \param each The object being reduced at this step of the reduction.
///
/// \return The result of this step of the reduction, which will become the value of \c into passed to the next step of the reduction.
typedef id(^REDReducingBlock)(id into, id each);


/// A piecewise-reducible collection.
@protocol REDReducible <NSObject>

/// Produce a piecewise reduction of the receiver.
///
/// \param initial The initial result of the reduction. This should be some identity element of the operation, i.e. 0 for addition, 1 for multiplication, or an empty collection or string for appending.
/// \param block The block used to reduce the receiver.
///
/// \return The result of applying the block to each eleemnt of the receiver, with \c initial used as the first result, and the result of the each successive step applied as the \c into parameter of the next step.
-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block;

@end


#pragma mark Early return

/// An object which signals the completion of reduction.
///
/// Returning an instance of \c REDReduced during reduction causes the instance’s wrapped object to be returned as the result of the reduction without further evaluation.
@interface REDReduced : NSObject

/// Returns an instance wrapping \c object.
+(instancetype)reduced:(id)object;

@property (readonly) id self;

@end


#pragma mark Categories

/// \c NSArray conforms to \c REDReducible.
@interface NSArray (REDReducible) <REDReducible>
@end


/// \c NSSet conforms to \c REDReducible.
@interface NSSet (REDReducible) <REDReducible>
@end


/// \c NSOrderedSet conforms to \c REDReducible.
@interface NSOrderedSet (REDReducible) <REDReducible>
@end


/// \c NSDictionary conforms to \c REDReducible.
///
/// Reduction traverses the keys (as with \c NSFastEnumeration).
@interface NSDictionary (REDReducible) <REDReducible>
@end


/// \c NSString conforms to \c REDReducible.
///
/// Reduction is performed by composed character sequence, i.e. composed characters, emoji, etc. will be represented as a string with \c length > 1.
@interface NSString (REDReducible) <REDReducible>
@end


/// \c NSAttributedString conforms to \c REDReducible.
///
/// Reduction is performed by composed character sequence, i.e. composed characters, emoji, etc. will be represented as a string with \c length > 1.
@interface NSAttributedString (REDReducible) <REDReducible>
@end


/// \c NSEnumerator conforms to \c REDReducible.
///
/// Reducing an enumerator with \c -red_reduce:usingBlock: uses \c -nextObject, and thus consumes all of the objects in the enumerator.
@interface NSEnumerator (REDReducible) <REDReducible>
@end
