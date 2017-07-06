//
//  CircleView.h
//  进度条究极版
//
//  Created by 孙昊 on 16/7/12.
//  Copyright © 2016年 sunhao. All rights reserved.
//

#import <UIKit/UIKit.h>
//先设置strokelineWidth, 然后再调用- (void)circleWithProgress方法
@interface CircleView : UIView
@property (nonatomic,strong) CAShapeLayer *backgroundLine;
@property (nonatomic,strong) CAShapeLayer *mainLine;
@property (nonatomic,assign) CGFloat strokelineWidth;
@property (nonatomic,strong) NSTimer *labelTimer;
- (void)circleWithProgress:(NSInteger)progress andIsAnimate:(BOOL)animate;

@end