//
//  NSArray+MDCQuickSelectTests.m
//  MDCQuickSelectTests
//
//  Created by Brian Ivan Gesiak on 5/22/14.
//
//

#import <XCTest/XCTest.h>
#import "MDCQuickSelect.h"

@interface NSArray_MDCQuickSelectTests : XCTestCase
@property (nonatomic, assign) NSComparator ascendingNumberComparator;
@property (nonatomic, assign) NSComparator descendingNumberComparator;
@end

@implementation NSArray_MDCQuickSelectTests

- (void)setUp {
    [super setUp];

    self.ascendingNumberComparator = ^NSComparisonResult(NSNumber *left, NSNumber *right){
        return [left compare:right];
    };
    self.descendingNumberComparator = ^NSComparisonResult(NSNumber *left, NSNumber *right){
        return [right compare:left];
    };
}

#pragma mark - -[NSArray mdc_objectAtIndex:inSortedArrayUsingComparator:]

- (void)testNthObjectWithOutOfBoundsIndexRaises {
    XCTAssertThrowsSpecificNamed([@[] mdc_objectAtIndex:0
                           inSortedArrayUsingComparator:nil],
                                 NSException,
                                 NSRangeException,
                                 @"Expected a request for objectAtIndex:0 of an empty array to raise");
}

- (void)testNthObjectWithNilComparatorRaises {
    XCTAssertThrowsSpecificNamed([@[ @0 ] mdc_objectAtIndex:0
                               inSortedArrayUsingComparator:nil],
                                 NSException,
                                 NSInternalInconsistencyException,
                                 @"Expected a nil comparator to raise");
}

- (void)testFirstObjectOfAOneElementArrayReturnsThatObject {
    XCTAssertEqualObjects([@[ @0 ] mdc_objectAtIndex:0
                        inSortedArrayUsingComparator:self.ascendingNumberComparator],
                          @0,
                          @"Expected smallest element of an array with 1 element to be that one element");
}

- (void)testNthObjectOfAnArray {
    NSArray *array = @[ @10, @3, @4, @99, @34, @(-1), @0, @21, @19 ];
    XCTAssertEqualObjects([array mdc_objectAtIndex:0
                      inSortedArrayUsingComparator:self.ascendingNumberComparator],
                          @(-1), @"Expected smallest element");
    XCTAssertEqualObjects([array mdc_objectAtIndex:1
                      inSortedArrayUsingComparator:self.ascendingNumberComparator],
                          @0, @"Expected second smallest element");
    XCTAssertEqualObjects([array mdc_objectAtIndex:2
                      inSortedArrayUsingComparator:self.ascendingNumberComparator],
                          @3, @"Expected third smallest element");
    XCTAssertEqualObjects([array mdc_objectAtIndex:3
                      inSortedArrayUsingComparator:self.ascendingNumberComparator],
                          @4, @"Expected fourth smallest element");
    XCTAssertEqualObjects([array mdc_objectAtIndex:4
                      inSortedArrayUsingComparator:self.ascendingNumberComparator],
                          @10, @"Expected fifth smallest element");
    XCTAssertEqualObjects([array mdc_objectAtIndex:5
                      inSortedArrayUsingComparator:self.ascendingNumberComparator],
                          @19, @"Expected sixth smallest element");
    XCTAssertEqualObjects([array mdc_objectAtIndex:6
                      inSortedArrayUsingComparator:self.ascendingNumberComparator],
                          @21, @"Expected seventh smallest element");
    XCTAssertEqualObjects([array mdc_objectAtIndex:7
                      inSortedArrayUsingComparator:self.ascendingNumberComparator],
                          @34, @"Expected eigth smallest element");
    XCTAssertEqualObjects([array mdc_objectAtIndex:8
                      inSortedArrayUsingComparator:self.ascendingNumberComparator],
                          @99, @"Expected ninth smallest element");

    XCTAssertEqualObjects([array mdc_objectAtIndex:8
                      inSortedArrayUsingComparator:self.descendingNumberComparator],
                          @(-1), @"Expected ninth largest element");
    XCTAssertEqualObjects([array mdc_objectAtIndex:7
                      inSortedArrayUsingComparator:self.descendingNumberComparator],
                          @0, @"Expected eigth largest element");
    XCTAssertEqualObjects([array mdc_objectAtIndex:6
                      inSortedArrayUsingComparator:self.descendingNumberComparator],
                          @3, @"Expected seventh largest element");
    XCTAssertEqualObjects([array mdc_objectAtIndex:5
                      inSortedArrayUsingComparator:self.descendingNumberComparator],
                          @4, @"Expected sixth largest element");
    XCTAssertEqualObjects([array mdc_objectAtIndex:4
                      inSortedArrayUsingComparator:self.descendingNumberComparator],
                          @10, @"Expected fifth largest element");
    XCTAssertEqualObjects([array mdc_objectAtIndex:3
                      inSortedArrayUsingComparator:self.descendingNumberComparator],
                          @19, @"Expected fourth largest element");
    XCTAssertEqualObjects([array mdc_objectAtIndex:2
                      inSortedArrayUsingComparator:self.descendingNumberComparator],
                          @21, @"Expected third largest element");
    XCTAssertEqualObjects([array mdc_objectAtIndex:1
                      inSortedArrayUsingComparator:self.descendingNumberComparator],
                          @34, @"Expected second largest element");
    XCTAssertEqualObjects([array mdc_objectAtIndex:0
                      inSortedArrayUsingComparator:self.descendingNumberComparator],
                          @99, @"Expected largest element");
}

#pragma mark - -[NSArray mdc_subarrayWithRange:inSortedArrayUsingComparator:]

- (void)testNMostObjectsWithOutOfBoundsIndexRaises {
    XCTAssertThrowsSpecificNamed([@[] mdc_subarrayWithRange:NSMakeRange(0, 1)
                               inSortedArrayUsingComparator:nil],
                                 NSException,
                                 NSRangeException,
                                 @"Expected a request for objectAtIndex:0 of an empty array to raise");
}

- (void)testNMostObjectsWithNilComparatorRaises {
    NSArray *array = @[ @0, @1 ];
    XCTAssertThrowsSpecificNamed([array mdc_subarrayWithRange:NSMakeRange(0, 1)
                                 inSortedArrayUsingComparator:nil],
                                 NSException,
                                 NSInternalInconsistencyException,
                                 @"Expected a nil comparator to raise");
}

- (void)testNMostObjectsOfAnArrayWithNObjectsToReturnsTheArray {
    NSArray *result = [@[ @0, @1 ] mdc_subarrayWithRange:NSMakeRange(0, 2)
                            inSortedArrayUsingComparator:self.ascendingNumberComparator];
    NSArray *expected = @[@0, @1];
    XCTAssertEqualObjects(result, expected, @"Expected '2 smallest elements' of an array with 2 elements to be those elements");
}

- (void)testNMostObjectsOfAnArray {
    NSArray *array = @[ @35, @21, @98, @100, @69, @4002, @1029, @10000, @456, @89,
                        @6782, @1245, @1256, @908, @100, @10, @12, @3, @5, @101,
                        @123, @197, @206, @1009, @408, @573, @306, @209, @81, @6 ];
    NSArray *sevenSmallest = @[ @3, @5, @6, @10, @12, @21, @35 ];

    XCTAssertEqualObjects([NSSet setWithArray:[array mdc_subarrayWithRange:NSMakeRange(0, 7)
                                              inSortedArrayUsingComparator:self.ascendingNumberComparator]],
                          [NSSet setWithArray:sevenSmallest],
                          @"Expected the seven smallest elements");
}

@end
