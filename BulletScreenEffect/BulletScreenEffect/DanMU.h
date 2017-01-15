//
//  DanMU.h
//  BulletScreenEffect
//
//  Created by 郑亚伟 on 2017/1/9.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    DanMuTypeOther, // 别人发的
    DanMuTypeMe, // 自己发的
} DanMuType;

@interface DanMU : NSObject
/**
 *  弹幕类型
 */
@property (nonatomic, assign) DanMuType type;
/**
 *  用户名
 */
@property (nonatomic, copy) NSString *username;
/**
 *  文本内容
 */
@property (nonatomic, copy) NSString *text;
/**
 *  头像
 */
@property (nonatomic, strong) UIImage *icon;
/**
 *  表情图片名数组
 */
@property (nonatomic, strong) NSArray <NSString *> *emotions;
/**
 *  字典转模型方法
 */
+(instancetype)danMuWithDict:(NSDictionary *)dict;

@end
