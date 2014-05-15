//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Reducers/REDFilter.h>
#import <Reducers/REDMap.h>

@protocol REDIdiom <NSObject>

-(instancetype)red_map:(REDMapBlock)map;
-(instancetype)red_flattenMap:(REDFlattenMapBlock)map;
-(instancetype)red_filter:(REDPredicateBlock)predicate;

@end
