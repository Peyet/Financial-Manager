//
//  NSString+Calculation.h
//  design
//
//  Created by PeyetZhao on 2022/3/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Calculation)

// 复杂计算公式计算,接口主方法
+ (NSString *)calcComplexFormulaString:(NSString *)formula;
// 利用替换先把重复元素替换掉,再根据length长度做判断
+ (NSInteger )getDuplicateSubStrCountInCompleteStr:(NSString *)completeStr withSubStr:(NSString *)subStr;

@end

NS_ASSUME_NONNULL_END
