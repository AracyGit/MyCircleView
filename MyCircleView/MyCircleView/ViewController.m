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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CircleView *view = [[CircleView alloc] initWithFrame:CGRectMake(0, 100, 300, 300)];
    view.strokelineWidth = 15;
    [self.view addSubview:view];
    [view circleWithProgress:90 andIsAnimate:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
