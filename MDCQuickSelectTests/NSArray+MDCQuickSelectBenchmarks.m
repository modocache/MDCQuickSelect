//
//  NSArray+MDCQuickSelectBenchmarks.m
//  MDCQuickSelect
//
//  Created by Brian Ivan Gesiak on 5/22/14.
//
//

#import <XCTest/XCTest.h>
#import "MDCQuickSelect.h"

#pragma mark - Naive Implementation

@interface NSArray (MDCBenchmark)

// Expose internally used naive methods.
- (id)mdc_naiveObjectAtIndex:(NSUInteger)index
inSortedArrayUsingComparator:(NSComparator)comparator;
- (NSArray *)mdc_naiveSubarrayWithRange:(NSRange)range
           inSortedArrayUsingComparator:(NSComparator)comparator;

@end

#pragma mark - Profiling Functions

// Declare internal GCD benchmarking function.
// See: http://nshipster.com/benchmarking/
extern uint64_t dispatch_benchmark(size_t count, void (^block)(void));

void profile_mdc_objectAtIndex_inSortedArrayUsingComparator(NSArray *array,
                                                            NSUInteger index,
                                                            NSComparator comparator,
                                                            size_t count) {
    __block id element = nil;
    uint64_t nanoseconds = dispatch_benchmark(count, ^{
        element = [array mdc_objectAtIndex:index inSortedArrayUsingComparator:comparator];
    });

    NSLog(@"-[NSArray mdc_objectAtIndex:inSortedArrayUsingComparator:] "
          @"Average runtime: %llu ns, element: %@",
          nanoseconds, element);
}

void profile_mdc_naiveObjectAtIndex_inSortedArrayUsingComparator(NSArray *array,
                                                                 NSUInteger index,
                                                                 NSComparator comparator,
                                                                 size_t count) {
    __block id element = nil;
    uint64_t nanoseconds = dispatch_benchmark(count, ^{
        element = [array mdc_naiveObjectAtIndex:index inSortedArrayUsingComparator:comparator];
    });

    NSLog(@"-[NSArray mdc_naiveObjectAtIndex:inSortedArrayUsingComparator:] "
          @"Average runtime: %llu ns, element: %@",
          nanoseconds, element);
}

void profile_mdc_subarrayWithRange_inSortedArrayUsingComparator(NSArray *array,
                                                                NSRange range,
                                                                NSComparator comparator,
                                                                size_t count) {
    __block NSArray *elements = nil;
    uint64_t nanoseconds = dispatch_benchmark(count, ^{
        elements = [array mdc_subarrayWithRange:range inSortedArrayUsingComparator:comparator];
    });

    NSLog(@"-[NSArray mdc_subarrayWithRange:inSortedArrayUsingComparator:] "
          @"Average runtime: %llu ns, elements: [%@ ... %@]",
          nanoseconds, [elements firstObject], [elements lastObject]);
}

void profile_mdc_naiveSubarrayWithRange_inSortedArrayUsingComparator(NSArray *array,
                                                                     NSRange range,
                                                                     NSComparator comparator,
                                                                     size_t count) {
    __block NSArray *elements = nil;
    uint64_t nanoseconds = dispatch_benchmark(count, ^{
        elements = [array mdc_naiveSubarrayWithRange:range inSortedArrayUsingComparator:comparator];
    });

    NSLog(@"-[NSArray mdc_naiveSubarrayWithRange:inSortedArrayUsingComparator:] "
          @"Average runtime: %llu ns, elements: [%@ ... %@]",
          nanoseconds, [elements firstObject], [elements lastObject]);
}

#pragma mark - Benchmarks

static const NSUInteger SmallArraySize = 10;
static const NSUInteger MediumArraySize = 150;
static const NSUInteger LargeArraySize = 1000;
static const NSUInteger HugeArraySize = 100000;

@interface NSArray_MDCQuickSelectBenchmarks : XCTestCase
@property (nonatomic, assign) NSComparator numberComparator;
@property (nonatomic, strong) NSArray *smallArray;
@property (nonatomic, strong) NSArray *mediumArray;
@property (nonatomic, strong) NSArray *largeArray;
@property (nonatomic, strong) NSArray *hugeArray;
@end

@implementation NSArray_MDCQuickSelectBenchmarks

- (void)setUp {
    [super setUp];

    self.numberComparator = ^NSComparisonResult(NSNumber *left, NSNumber *right){
        return [left compare:right];
    };

    NSMutableArray *random = [NSMutableArray array];
    for (NSUInteger i = 0; i < SmallArraySize; ++i) {
        [random addObject:@(arc4random() % SmallArraySize)];
    }
    self.smallArray = [random copy];

    [random removeAllObjects];
    for (NSUInteger i = 0; i < MediumArraySize; ++i) {
        [random addObject:@(arc4random() % MediumArraySize)];
    }
    self.mediumArray = [random copy];

    [random removeAllObjects];
    for (NSUInteger i = 0; i < LargeArraySize; ++i) {
        [random addObject:@(arc4random() % LargeArraySize)];
    }
    self.largeArray = [random copy];

    [random removeAllObjects];
    for (NSUInteger i = 0; i < HugeArraySize; ++i) {
        [random addObject:@(arc4random() % HugeArraySize)];
    }
    self.hugeArray = [random copy];
}

- (void)test30thSmallestElementOfLargeArray {
    NSLog(@" ");
    NSLog(@"-------- BENCHMARKS --------");
    NSLog(@" ");

    NSLog(@"*** Profiling with small array (%lu elements) of numbers...", [self.smallArray count]);
    profile_mdc_objectAtIndex_inSortedArrayUsingComparator(self.smallArray, 3, self.numberComparator, 10000);
    profile_mdc_naiveObjectAtIndex_inSortedArrayUsingComparator(self.smallArray, 3, self.numberComparator, 10000);
    profile_mdc_subarrayWithRange_inSortedArrayUsingComparator(self.smallArray, NSMakeRange(0, 3), self.numberComparator, 10000);
    profile_mdc_naiveSubarrayWithRange_inSortedArrayUsingComparator(self.smallArray, NSMakeRange(0, 3), self.numberComparator, 10000);

    NSLog(@"*** Profiling with medium array (%lu elements) of numbers...", [self.mediumArray count]);
    profile_mdc_objectAtIndex_inSortedArrayUsingComparator(self.mediumArray, 15, self.numberComparator, 10000);
    profile_mdc_naiveObjectAtIndex_inSortedArrayUsingComparator(self.mediumArray, 15, self.numberComparator, 10000);
    profile_mdc_subarrayWithRange_inSortedArrayUsingComparator(self.mediumArray, NSMakeRange(0, 30), self.numberComparator, 10000);
    profile_mdc_naiveSubarrayWithRange_inSortedArrayUsingComparator(self.mediumArray, NSMakeRange(0, 30), self.numberComparator, 10000);

    NSLog(@"*** Profiling with large array (%lu elements) of numbers...", [self.largeArray count]);
    profile_mdc_objectAtIndex_inSortedArrayUsingComparator(self.largeArray, 30, self.numberComparator, 10000);
    profile_mdc_naiveObjectAtIndex_inSortedArrayUsingComparator(self.largeArray, 30, self.numberComparator, 10000);
    profile_mdc_subarrayWithRange_inSortedArrayUsingComparator(self.largeArray, NSMakeRange(0, 30), self.numberComparator, 10000);
    profile_mdc_naiveSubarrayWithRange_inSortedArrayUsingComparator(self.largeArray, NSMakeRange(0, 30), self.numberComparator, 10000);

    NSLog(@"*** Profiling with huge array (%lu elements) of numbers...", [self.hugeArray count]);
    profile_mdc_objectAtIndex_inSortedArrayUsingComparator(self.hugeArray, 300, self.numberComparator, 100);
    profile_mdc_naiveObjectAtIndex_inSortedArrayUsingComparator(self.hugeArray, 300, self.numberComparator, 100);
    profile_mdc_subarrayWithRange_inSortedArrayUsingComparator(self.hugeArray, NSMakeRange(0, 300), self.numberComparator, 100);
    profile_mdc_naiveSubarrayWithRange_inSortedArrayUsingComparator(self.hugeArray, NSMakeRange(0, 300), self.numberComparator, 100);

    NSLog(@" ");
    NSLog(@"----------------------------");
    NSLog(@" ");
}

@end
