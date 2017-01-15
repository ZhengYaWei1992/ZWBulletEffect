//
//  DanMuView.m
//  BulletScreenEffect
//
//  Created by 郑亚伟 on 2017/1/8.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "DanMuView.h"


@interface DanMuView ()
/**
 图片数组
 */
@property(nonatomic,strong)NSMutableArray *images;
/**
 定时器
 */
@property(nonatomic,strong)CADisplayLink *link;
/**
 将要删除的图片数组
 */
@property(nonatomic,strong)NSMutableArray *deleteImages;

@end
@implementation DanMuView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    for (ZWImage *image in self.images) {
         image.x -= 2.5;
         [image drawAtPoint:CGPointMake(image.x, image.y)];
        //判断图片是否已经超出屏幕,如果超出则移除
        if (image.x + image.size.width < 0) {
            //注意：OC语法规定，不能在遍历数组的时候，删除数组中的元素，否则会崩溃.这里的数组是指同一个数组
            //[self.images removeObject:image];
            [self.deleteImages addObject:image];
        }
    }
    
    //遍历deleteImages数组
    for (ZWImage *image in self.deleteImages) {
        //添加过图片后要删除，不能无限制的增加内存
        [self.images removeObject:image];
    }
    //删除deleteImages中的图片
    [self.deleteImages removeAllObjects];
}
/*
 根据模型生成一张图片，这个方法主要对外提供
 */
-(ZWImage *)imageViewDanMU:(DanMU *)danMu{
    //0.计算生成image的大小
    //字体大小
    UIFont *font = [UIFont systemFontOfSize:13];
    //间距
    CGFloat marginX = 5;
    //头像的尺寸
    CGFloat iconH = 30;
    CGFloat iconW = iconH;
    //用户名占据的大小
    CGSize userNameSize = [danMu.username boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    CGFloat nameWidth = userNameSize.width;
    CGFloat nameHeight = userNameSize.height;
    //文本内容占据的大小
     CGSize textSize = [danMu.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    CGFloat textWidth = textSize.width;
    CGFloat textHeight = textSize.height;
    
    //内容表情图片的尺寸
    CGFloat emotionW = 25;
    CGFloat emotionH = emotionW;
    //计算一张image的大小
    CGFloat contentH = 30;
    CGFloat contentW =marginX + iconW + marginX + userNameSize.width + marginX + textSize.width + danMu.emotions.count * emotionW;
   

    // 1.开启位图上下文  画板大小  是否透明
    CGSize contentSize = CGSizeMake(contentW,contentH);
    UIGraphicsBeginImageContextWithOptions(contentSize, NO, 0.0);
    //2.获取上下文
    CGContextRef ctx =UIGraphicsGetCurrentContext();
    // ====保存位图上下文到栈中====
    CGContextSaveGState(ctx);
    //================================================
    //3.1、绘制圆形的头像
    CGRect iconFrame = CGRectMake(0, 0, iconW, iconH);
    CGContextAddEllipseInRect(ctx, iconFrame);
    CGContextClip(ctx);
    UIImage *icon = danMu.type? [UIImage imageNamed:@"me"] :[UIImage imageNamed:@"your"];
    [icon drawInRect:iconFrame];
    //===将位图上下文出栈====   保存和拉出问题上下文出站，主要是防止之前的设置对之后的绘制不影响，如上面的CGContextClip(ctx);
    CGContextRestoreGState(ctx);
    
    //================================================
    //3.2、绘制文本背景颜色、文本背景颜色、文本（用户名和评论内容）
    //绘制文本背景颜色
    if (danMu.type == DanMuTypeMe) {
        // 本人发的为红色
        [[UIColor colorWithRed:248 / 255.0 green:100 / 255.0 blue:66/255.0 alpha:0.9] set];
    } else {
        // 其他人发的为白色
        [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9] set];
    }
    //绘制文本背景
    CGFloat textBackgroundX = iconW + marginX;
    CGFloat textBackgroundY = 0;
    CGFloat textBackgroundW = contentW - textBackgroundX;
    CGFloat textBackgroundH = contentH;
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(textBackgroundX, textBackgroundY,textBackgroundW , textBackgroundH) cornerRadius:20] fill];
    // 用户名
    CGFloat nameX = textBackgroundX + marginX;
    //注意这里要让文字居中显示
    CGFloat nameY = (contentH - textHeight) * 0.5;
    CGRect nameRect = CGRectMake(nameX, nameY, nameWidth, nameHeight);
    [danMu.username drawInRect:nameRect withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:(danMu.type == DanMuTypeMe) ? [UIColor blackColor]:[UIColor orangeColor]}];
    //内容
    CGFloat textX = nameX + nameWidth + marginX;
    CGFloat textY = (contentH - textHeight) * 0.5;
    CGRect textRect = CGRectMake(textX, textY, textWidth, textHeight);
    [danMu.text drawInRect:textRect withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:(danMu.type == DanMuTypeMe) ? [UIColor whiteColor]:[UIColor blackColor]}];
    //3.3、绘制表情图片
    __block CGFloat emotionX = textX + textWidth;
    CGFloat emotionY = (contentH - emotionH) * 0.5 ;
    [danMu.emotions enumerateObjectsUsingBlock:^(NSString * _Nonnull emotionName, NSUInteger idx, BOOL * _Nonnull stop) {
        // 加载表情图片
        UIImage *emotion = [UIImage imageNamed:emotionName];
        // 绘制表情图片
        [emotion drawInRect:CGRectMake(emotionX, emotionY, emotionW, emotionH)];
        // 修改emotionX
        emotionX += emotionW;
    }];
    //4.获取绘制好的图片
   UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
   //5.关闭上下文
    UIGraphicsEndImageContext();
   return [[ZWImage alloc]initWithCGImage:image.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
}

/**
 对外提供
 */
- (void)addImage:(ZWImage *)image{
    [self.images addObject:image];
    //添加图片的时候再开启定时器，而不是初始化就开启定时器，因为可能刚进入的时候并没有弹幕，所以不用开启定时器，但是定时器也不能开多，要用赖加载判断
    [self addTimer];
    [self setNeedsDisplay];
}




#pragma mark - 添加定时器
- (void)addTimer{
    if (self.link) {
        return;
    }
    //定时器直接调用系统方法  setNeedsDisplay会调用drawRect方法
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.link = link;
}

#pragma mark - getter方法
- (NSMutableArray *)images{
    if (_images == nil ) {
        _images = [NSMutableArray array];
    }
    return _images;
}
- (NSMutableArray *)deleteImages{
    if (_deleteImages == nil) {
        _deleteImages = [NSMutableArray array];
    }
    return _deleteImages;
}


@end
