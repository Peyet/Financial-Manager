//
//  FMCategory.m
//  design
//
//  Created by PeyetZhao on 2022/3/14.
//

#import "FMCategory.h"

@implementation FMCategory

#pragma mark - Category数据模型的默认设置
+ (NSString *)primaryKey {
    return kCATPrimaryKey;
}

+ (NSArray<NSString *> *)requiredProperties {
    return @[kCATTitle, kCATImage, kCATIncome];
}

+ (NSDictionary *)defaultPropertyValues {
    return @{kCATImage : @"defaultCategoryImage"};
}

+ (NSDictionary<NSString *,RLMPropertyDescriptor *> *)linkingObjectsProperties {
    return @{ kCATBill: [RLMPropertyDescriptor descriptorWithClass:FMBill.class propertyName:@"category"],
              kCATBudget : [RLMPropertyDescriptor descriptorWithClass:FMBudget.class propertyName:@"category"]
    };
}

#pragma mark - public method

/// 初始化类别
/// @param dictionary 字典信息
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

/// 修改类别名称
/// @param title 类别名称
- (void)updateTitle:(NSString *)title {
    @autoreleasepool {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            self.categoryTitle = title;
        }];
    }
}
/// 修改类别图标
/// @param image 类别图标文件名
- (void)updateImage:(NSString *)image {
    @autoreleasepool {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            self.categoryImage = image;
        }];
    }
}
/// 修改类别收支
/// @param isIncome 类别收支
- (void)updateIncome:(NSNumber<RLMBool> *)isIncome {
    @autoreleasepool {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            self.isIncome = isIncome;
        }];
    }
}


#pragma mark - private method
/// 生成64位随机字符串作为主键
-(NSString *)ret64bitString {
    char data[64];
    for (int x=0; x <64; data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:64 encoding:NSUTF8StringEncoding];
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

#pragma mark - 懒加载
- (NSString *)categoryID {
    if (!_categoryID) {
        _categoryID = [self ret64bitString];
    }
    return _categoryID;
}

//- (UIImage *)categoryImage {
//    return [UIImage imageNamed:self.categoryImage];
//}
//
///* --------------------------read plist----------------------------- */
//- (instancetype)initWithDic:(NSDictionary *)dic {
//    if (self = [super init]) {
//        [self setValuesForKeysWithDictionary:dic];
//    }
//    return self;
//}
//
//+ (instancetype)categoryWithDic:(NSDictionary *)dic {
//    return  [[self alloc]initWithDic:dic];
//}
//
//+ (NSArray *)categoryList {
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"category" ofType:@"plist"];
//    NSArray *dicArray = [NSArray arrayWithContentsOfFile:path];
//    NSMutableArray *tempArray = [NSMutableArray array];
//
//    for (NSDictionary *dic in dicArray) {
//        FMCategory *category = [FMCategory categoryWithDic:dic];
//        [tempArray addObject:category];
//    }
//    return tempArray;
//}
//
//#pragma mark - 修改
//- (void)modifyCategoryTitle:(NSString *)categoryTitle {
//    if ([self.categoryTitle isEqualToString:categoryTitle])return;
//    RLMRealm *realm = RLMRealm.defaultRealm;
//    FMCategory *category = [[FMCategory objectsWhere:@"categoryID == %@",self.categoryID] firstObject];
//    [realm transactionWithBlock:^{
//        category.categoryTitle = categoryTitle;
//    }];
//}

@end
