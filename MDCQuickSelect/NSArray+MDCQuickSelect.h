//
//  NSArray+MDCQuickSelect.h
//  MDCQuickSelect
//
//  Created by Brian Ivan Gesiak on 5/22/14.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (MDCQuickSelect)

- (id)mdc_objectAtIndex:(NSUInteger)index inSortedArrayUsingComparator:(NSComparator)comparator;
- (NSArray *)mdc_subarrayWithRange:(NSRange)range
      inSortedArrayUsingComparator:(NSComparator)comparator;

@end
