//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Reducers/REDReducible.h>

/// A collection or other object which can be appended onto.
@protocol REDAppendable <NSObject>

/// Append the objects in \c from onto \c self.
///
/// \param from The reducible to append onto \c self.
///
/// \return An appendable with the objects in \c from appended onto it. This should generally be a (presumably immutable) copy, and thus, where applicable, should be typed as the receiving class’ immutable superclass, rather than \c instancetype.
-(instancetype)red_append:(id<REDReducible>)from;

/// Calls \c -red_append: on an empty instance of \c self.
+(instancetype)red_append:(id<REDReducible>)from;

@end


#pragma mark Categories

/// \c NSArray conforms to \c REDAppendable.
@interface NSArray (REDAppendable) <REDAppendable>

-(NSArray *)red_append:(id<REDReducible>)from;

@end


/// \c NSSet conforms to \c REDAppendable.
@interface NSSet (REDAppendable) <REDAppendable>

-(NSSet *)red_append:(id<REDReducible>)from;

@end


/// \c NSOrderedSet conforms to \c REDAppendable.
@interface NSOrderedSet (REDAppendable) <REDAppendable>

-(NSOrderedSet *)red_append:(id<REDReducible>)from;

@end


/// \c NSDictionary conforms to \c REDAppendable.
///
/// The reducible being appended must produce objects conforming to \c REDKeyValuePair, and the pairs’ keys and values must not be nil.
@interface NSDictionary (REDAppendable) <REDAppendable>

-(NSDictionary *)red_append:(id<REDReducible>)from;

@end


/// \c NSString conforms to \c REDAppendable.
///
/// The reducible being appended will have \c -description called on each of its elements, and those descriptions will be appended onto the receiver.
@interface NSString (REDAppendable) <REDAppendable>

-(NSString *)red_append:(id<REDReducible>)from;

@end


/// \c NSAttributedString conforms to \c REDAppendable.
@interface NSAttributedString (REDAppendable) <REDAppendable>

-(NSAttributedString *)red_append:(id<REDReducible>)from;

@end

