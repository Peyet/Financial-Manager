//
//  NSArray+Extension.m
//  design
//
//  Created by PeyetZhao on 2022/3/21.
//

#import "NSArray+Extension.h"

@implementation NSArray (Extension)

+ (NSArray *)arrayWithRLMResults:(nonnull RLMResults *)results {
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:10];
    for (id object in results) {
        [mutableArray addObject:object];
    }
    return [mutableArray copy];
}

@end
