//
//  ViewController.m
//  MyCircleView
//
//  Created by 孙昊 on 2017/7/6.
//  Copyright © 2017年 sunhao. All rights reserved.
//

#import "ViewController.h"
#import "CircleView.h"
@interface ViewController ()
@property (nonatomic,strong) CircleView *circleV;
@end

@implementation ViewController

- (void)viewDidLoad {
   [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100, 350, 50, 30);
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(circleShow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)circleShow{
    if (_circleV) {
        [_circleV removeFromSuperview];
    }
    
    _circleV = [[CircleView alloc] initWithFrame:CGRectMake(200, 100, 200, 200)];
    //进度条宽度
    _circleV.strokelineWidth = 15;
    [self.view addSubview:_circleV];
    //设置进度,是否有动画效果
    [_circleV circleWithProgress:90 andIsAnimate:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
