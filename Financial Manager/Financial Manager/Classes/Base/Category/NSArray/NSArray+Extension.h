//
//  NSArray+Extension.h
//  design
//
//  Created by PeyetZhao on 2022/3/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Extension)

+ (NSArray *)arrayWithRLMResults:(nonnull RLMResults *)results;

@end

NS_ASSUME_NONNULL_END
