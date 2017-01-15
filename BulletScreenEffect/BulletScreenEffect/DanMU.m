//
//  DanMU.m
//  BulletScreenEffect
//
//  Created by 郑亚伟 on 2017/1/9.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "DanMU.h"

@implementation DanMU
/**
 *  字典转模型方法
 */
+ (instancetype)danMuWithDict:(NSDictionary *)dict {
    id obj = [[self alloc] init];
    
    [obj setValuesForKeysWithDictionary:dict];
    
    return obj;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end
