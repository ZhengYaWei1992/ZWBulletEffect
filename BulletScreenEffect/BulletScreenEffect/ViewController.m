//
//  ViewController.m
//  BulletScreenEffect
//
//  Created by 郑亚伟 on 2017/1/8.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "ViewController.h"
#import "DanMuView.h"
#import "ZWImage.h"
#import "DanMU.h"

@interface ViewController ()
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)DanMuView *danMuView;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)UISwitch *s;

/**
 弹幕模型数组
 */
@property(nonatomic,strong)NSMutableArray *danMus;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageView];
    [self.imageView addSubview:self.danMuView];
    [self.imageView addSubview:self.s];
    [self loadData];
    [self addTimer];
    
}
- (void)addTimer{
    self.timer.fireDate = [NSDate distantPast];
}
#pragma mark - 定时器事件
-(void)onTimer{
    //获取一个随机模型
    NSInteger index = arc4random_uniform((u_int32_t)self.danMus.count);//0-----self.danMus.count-1
    DanMU *danMU = self.danMus[index];
    //根据模型生成一张图片
    ZWImage *image = [self.danMuView imageViewDanMU:danMU];
    image.x = self.view.frame.size.width;
    //这个高度不能超过弹幕的高度
    image.y = arc4random_uniform(self.danMuView.frame.size.height - image.size.height);
    [self.danMuView addImage:image];
}
#pragma mark - 关闭或开启弹幕
-(void)startOrPauseBulletScreen:(UISwitch *)s{
    if (s.isOn) {
        self.timer.fireDate = [NSDate distantPast];
        self.danMuView.hidden = NO;
    }else{
        self.timer.fireDate = [NSDate distantFuture];
        self.danMuView.hidden = YES;
    }
}

#pragma mark - 加载弹幕数据
- (void)loadData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"danMu.plist" ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray *danMus = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        DanMU *danMu = [DanMU danMuWithDict:dict];
        [danMus addObject:danMu];
    }
    self.danMus = danMus.copy;
}

-(void)dealloc{
    [_timer invalidate];
}







-(UISwitch *)s{
    if (_s == nil) {
        _s = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 60, CGRectGetMaxY(self.imageView.frame) - 55, 50, 30)];
        [_s setOn:YES];
        [_s addTarget:self action:@selector(startOrPauseBulletScreen:) forControlEvents:UIControlEventValueChanged];
    }
    return _s;
}

- (NSTimer *)timer{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
    return _timer;
}


- (DanMuView *)danMuView{
    if (_danMuView == nil) {
        _danMuView= [[DanMuView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 260)];
//        _danMuView.backgroundColor = [UIColor lightGrayColor];
//        _danMuView.alpha = 0.5;
    }
    return _danMuView;
}

- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"2"]];
        _imageView.frame = CGRectMake(0, 20, self.view.frame.size.width, 300);
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}
- (NSMutableArray *)danMus{
    if (_danMus == nil) {
        _danMus = [NSMutableArray array];
    }
    return _danMus;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //加载图片
    //因为这个方法写死了，返回的就是UIImage，不能强制给返回ZWImage，而应该选择一个返回instancetype的方法,选择initWithContentsOfFile方法
    //ZWImage *image = [ZWImage imageNamed:@"d1"];
    //    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"d1" ofType:@".png"];
    //    ZWImage *image = [[ZWImage alloc]initWithContentsOfFile:filePath];
    //    image.x = self.view.frame.size.width;
    //    //这个高度不能超过弹幕的高度
    //    image.y = arc4random_uniform(self.danMuView.frame.size.height - image.size.height);
    //    [self.danMuView addImage:image];
    
    
    /*//获取一个随机模型
     NSInteger index = arc4random_uniform((u_int32_t)self.danMus.count);//0-----self.danMus.count-1
     DanMU *danMU = self.danMus[index];
     //根据模型生成一张图片
     ZWImage *image = [self.danMuView imageViewDanMU:danMU];
     image.x = self.view.frame.size.width;
     //这个高度不能超过弹幕的高度
     image.y = arc4random_uniform(self.danMuView.frame.size.height - image.size.height);
     [self.danMuView addImage:image];*/
}


@end
