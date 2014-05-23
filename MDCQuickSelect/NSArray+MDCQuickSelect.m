//
//  NSArray+MDCQuickSelect.m
//  MDCQuickSelect
//
//  Created by Brian Ivan Gesiak on 5/22/14.
//
//

#import "NSArray+MDCQuickSelect.h"

@implementation NSArray (MDCQuickSelect)

#pragma mark - Public Interface

- (id)mdc_objectAtIndex:(NSUInteger)index inSortedArrayUsingComparator:(NSComparator)comparator {
    // Sanity checks:
    //   - index must not exceed bounds of array
    //   - comparator must not be nil
    if (index >= [self count]) {
        [NSException raise:NSRangeException
                    format:@"*** %@: index %lu beyond bounds [0 .. %lu]",
                           NSStringFromSelector(_cmd),
                           (unsigned long)index,
                           (unsigned long)[self count]];
    }
    NSParameterAssert(comparator != nil);

    // The overhead of quickselect outweighs its benefits when the array is
    // sufficiently small. Perform a naive sort and index in small enough cases.
    if ([self count] <= 100) {
        return [self mdc_naiveObjectAtIndex:index inSortedArrayUsingComparator:comparator];
    }

    // Select a pivot from the array.
    NSUInteger pivotIndex = [self count]/2;
    id pivot = [self objectAtIndex:pivotIndex];

    // Create an array with all elements besides that pivot.
    NSArray *before = [self subarrayWithRange:NSMakeRange(0, pivotIndex)];
    NSArray *after = [self subarrayWithRange:NSMakeRange(pivotIndex + 1, [self count] - pivotIndex - 1)];
    NSArray *elements = [before arrayByAddingObjectsFromArray:after];

    // Each element besides the pivot is added to "less" or "greater" arrays.
    NSMutableArray *lesser = [NSMutableArray arrayWithCapacity:[elements count]];
    NSMutableArray *greater = [NSMutableArray arrayWithCapacity:[elements count]];
    for (id element in elements) {
        if (comparator(element, pivot) == NSOrderedDescending) {
            [greater addObject:element];
        } else {
            [lesser addObject:element];
        }
    }

    if (index == [lesser count]) {
        // If looking for element at index 30, and there are 30 elements [0..29]
        // in the lesser array, then the pivot is the element we're looking for.
        return pivot;
    } else if (index < [lesser count]) {
        // If looking for element at index 29, and there are 30 elements [0..29]
        // in the lesser array, then recurse into lesser array.
        return [lesser mdc_objectAtIndex:index inSortedArrayUsingComparator:comparator];
    } else {
        // If looking for element at index 35, and there are 30 elements [0..29]
        // in the lesser array, then we need to find the index 4 element in the greater
        // array: index 35 - indices [0..29] from lesser - pivot index == 4.
        return [greater mdc_objectAtIndex:index - [lesser count] - 1
             inSortedArrayUsingComparator:comparator];
    }
}

- (NSArray *)mdc_subarrayWithRange:(NSRange)range
      inSortedArrayUsingComparator:(NSComparator)comparator {
    NSUInteger count = range.location + range.length;

    // Sanity checks:
    //   - count must not exceed bounds of array
    //   - comparator must not be nil
    if (count > [self count]) {
        [NSException raise:NSRangeException
                    format:@"*** %@: range (%lu...%lu) beyond bounds [0 .. %lu]",
                           NSStringFromSelector(_cmd),
                           (unsigned long)range.location,
                           (unsigned long)range.length,
                           (unsigned long)[self count]];
    }
    NSParameterAssert(comparator != nil);

    if ([self count] == count) {
        // If looking for the n smallest elements in an array
        // of n elements, simply return the array.
        return self;
    } else if ([self count] < 100) {
        // The overhead of quickselect outweighs its benefits when the array is
        // sufficiently small. Perform a naive sort and index in small enough cases.
        return [self mdc_naiveSubarrayWithRange:range inSortedArrayUsingComparator:comparator];
    }

    // Find the n-th smallest element.
    id pivot = [self mdc_objectAtIndex:count - 1 inSortedArrayUsingComparator:comparator];

    // Begin compiling a list of smaller elements, until we reach the amount we need.
    NSMutableArray *elements = [NSMutableArray arrayWithCapacity:count];
    for (id element in self) {
        if ([elements count] == count) {
            return [elements subarrayWithRange:range];
        }

        if (comparator(element, pivot) != NSOrderedDescending) {
            [elements addObject:element];
        }
    }

    return [elements subarrayWithRange:range];
}

#pragma mark - Internal Methods

- (id)mdc_naiveObjectAtIndex:(NSUInteger)index
inSortedArrayUsingComparator:(NSComparator)comparator {
    NSArray *sorted = [self sortedArrayUsingComparator:comparator];
    return sorted[index];
}

- (NSArray *)mdc_naiveSubarrayWithRange:(NSRange)range
           inSortedArrayUsingComparator:(NSComparator)comparator {
    NSArray *sorted = [self sortedArrayUsingComparator:comparator];
    return [sorted subarrayWithRange:range];
}

@end
