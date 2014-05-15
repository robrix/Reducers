//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Reducers/REDFilter.h>
#import <Reducers/REDMap.h>

#pragma mark Idiom

@protocol REDIdiom <NSObject>

-(id<REDReducible>)red_map:(REDMapBlock)map;
-(id<REDReducible>)red_flattenMap:(REDFlattenMapBlock)map;
-(id<REDReducible>)red_filter:(REDPredicateBlock)predicate;

@end


#pragma mark Categories

@interface NSArray (REDIdiom) <REDIdiom>
@end
