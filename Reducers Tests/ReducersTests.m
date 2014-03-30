//  Copyright (c) 2014 Rob Rix. All rights reserved.

//  This file is a stub to compile unit test bundles with. Doesn’t really need anything in it.
@interface ReducersTests : XCTestCase
@end

@implementation ReducersTests

+(XCTest *)defaultTestSuite {
	return [L3TestSuite suiteForExecutablePath:@L3_BUNDLE_LOADER];
}

@end