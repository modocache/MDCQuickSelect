# MDCQuickSelect

[![Build Status](https://travis-ci.org/modocache/MDCQuickSelect.svg?branch=master)](https://travis-ci.org/modocache/MDCQuickSelect)

Categories to quickly select the "n-th most" element, or the "n most"
elements (unsorted) in an array.

For example, if you need to find the tenth smallest number in an array of 100,000:

```objc
#import <MDCQuickSelect/MDCQuickSelect.h>

// 79% faster than sorting the numbers and accessing -objectAtIndex:10
NSNumber *tenth = [numbers mdc_objectAtIndex:10
                    inSortedArrayUsingComparator:^NSComparisonResult(NSNumber *left, NSNumber *right) {
                        return [left compare: right];
                    }];
```

Or to find the ten smallest numbers in an array of 100,000:

```objc
// 71% faster than sorting the numbers and accessing -subarrayWithRange:NSMakeRange(0, 10)
[numbers mdc_subarrayWithRange:NSMakeRange(0, 10)
 inSortedArrayUsingComparator:^NSComparisonResult(NSNumber *left, NSNumber *right){
                                  return [left.numberOfFriends compare:right.numberOfFriends];
                              }];
```

The improved performance is achieved by using the quickselect algorithm, developed by
Tony Hoare, inventor of quicksort.

Performance is infinitesimally worse when array size is less than 150 elements. For arrays
larger than 150 elements, MDCQuickSelect outperforms the naive approach, sometimes by vast margins.
Run the benchmarking tests and see for yourself!

