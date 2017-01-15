//
//  DanMuView.h
//  BulletScreenEffect
//
//  Created by 郑亚伟 on 2017/1/8.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWImage.h"
#import "DanMU.h"
@interface DanMuView : UIView

/**
 添加弹幕图片
 */
- (void)addImage:(ZWImage *)image;


/**
 根据弹幕模型生成一张图片
 */
-(ZWImage *)imageViewDanMU:(DanMU *)danMu;


@end
