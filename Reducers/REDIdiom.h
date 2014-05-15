//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Reducers/REDConvolve.h>
#import <Reducers/REDFilter.h>
#import <Reducers/REDMap.h>

#pragma mark Idiom

@protocol REDIdiom <NSObject>

-(id<REDReducible>)red_map:(REDMapBlock)map;
-(id<REDReducible>)red_flattenMap:(REDFlattenMapBlock)map;

-(id<REDReducible>)red_filter:(REDPredicateBlock)predicate;

-(id<REDReducible>)red_join:(id)separator;

-(id<REDIterable, REDReducible>)red_convolve:(REDConvolutionBlock)convolution;

@end


#pragma mark Categories

@interface NSArray (REDIdiom) <REDIdiom>
@end
