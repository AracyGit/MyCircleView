//
//  CircleView.m
//  进度条究极版
//
//  Created by 孙昊 on 16/7/12.
//  Copyright © 2016年 sunhao. All rights reserved.
//

#import "CircleView.h"

#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"//;
@interface CircleView ()
@property (nonatomic,strong) UILabel *numbLb;
@property (nonatomic,assign) CGFloat progressFlag;
@property (nonatomic,assign) NSInteger progressValue;
@property (nonatomic,strong) CAGradientLayer *grain;
@end
@implementation CircleView

- (void)circleWithProgress:(NSInteger)progress andIsAnimate:(BOOL)animate{
    if (animate) {
       
        _progressFlag = 0;
        _progressValue = progress;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:self.bounds.size.width/2 - _strokelineWidth startAngle:M_PI_2 endAngle:M_PI_2 + M_PI*2 clockwise:YES];
        
        self.backgroundLine.path = path.CGPath;
        self.mainLine.path = path.CGPath;
        [self.grain setMask:_mainLine];
        
        CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnima.duration = progress/100.0f;
        pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnima.toValue = [NSNumber numberWithFloat:progress/100.f];
        pathAnima.fillMode = kCAFillModeForwards;
        pathAnima.removedOnCompletion = NO;
        
        [_mainLine addAnimation:pathAnima forKey:@"strokeEndAnimation"];
        
        if (progress>0){
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                _labelTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(NameLbChange) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] run];
            });
        }
        
    }else{
        
        self.numbLb.attributedText = [self labelStytle:progress];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:self.bounds.size.width/2 - _strokelineWidth startAngle:M_PI_2 endAngle:M_PI_2 + M_PI*2 clockwise:YES];
        
        self.backgroundLine.path = path.CGPath;
        self.mainLine.path = path.CGPath;
        self.mainLine.strokeStart = 0.f;
        self.mainLine.strokeEnd = progress/100.f;
        [self.grain setMask:self.mainLine];
    }
}
-(NSMutableAttributedString*)labelStytle:(NSInteger)value{
    NSString* pace=[NSString stringWithFormat:@"%ld%@",value,@"%"];
    NSMutableAttributedString* pace1=[[NSMutableAttributedString alloc]initWithString:pace];
    [pace1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, pace.length-1)];
    [pace1 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(pace.length-1, 1)];
    NSRange titleRange = NSMakeRange(0, pace.length);
    [pace1 addAttribute:NSForegroundColorAttributeName
                  value:[self colorWithHexString:@"#37b2f5"]
                  range:titleRange];
    return pace1;
}
- (void)NameLbChange{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.numbLb.attributedText = [self labelStytle:_progressFlag];
    });
    
    if (_progressFlag >= _progressValue-1) {
        [_labelTimer invalidate];
        _labelTimer = nil;
    }
    _progressFlag += 1;
}



#pragma mark - 懒加载 Lazy Load
- (UILabel *)numbLb {
    if(_numbLb == nil) {
        _numbLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _numbLb.center = CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2);
        _numbLb.textAlignment = NSTextAlignmentCenter;
        int fontNum = self.bounds.size.width/6;
        _numbLb.font = [UIFont boldSystemFontOfSize:fontNum];
        _numbLb.text = @"0";
        //        _numbLb.backgroundColor = [UIColor redColor];
        [self addSubview:_numbLb];
    }
    return _numbLb;
}
- (CAShapeLayer *)backgroundLine {
    if(_backgroundLine == nil) {
        _backgroundLine = [[CAShapeLayer alloc] init];
        _backgroundLine.fillColor = [UIColor clearColor].CGColor;
        _backgroundLine.strokeColor = [UIColor lightGrayColor].CGColor;
        _backgroundLine.lineWidth = _strokelineWidth;
        [self.layer addSublayer:_backgroundLine];
    }
    return _backgroundLine;
}

- (CAShapeLayer *)mainLine {
    if(_mainLine == nil) {
        _mainLine = [[CAShapeLayer alloc] init];
        _mainLine.fillColor = [UIColor clearColor].CGColor;
        _mainLine.strokeColor = [UIColor redColor].CGColor;
        _mainLine.lineWidth = _strokelineWidth;
        [self.layer addSublayer:_mainLine];

    }
    return _mainLine;
}


- (CAGradientLayer *)grain {
	if(_grain == nil) {
		_grain = [[CAGradientLayer alloc] init];
        _grain.frame = CGRectMake(0, 0, self.bounds.size.width,self.bounds.size.height);
        [_grain setColors:[NSArray arrayWithObjects:
                           (id)[[self colorWithHexString:@"f31414"] CGColor],
                           (id)[[self colorWithHexString:@"f27200"] CGColor],
                           (id)[[self colorWithHexString:@"ffff00"] CGColor],
                           (id)[[self colorWithHexString:@"2bee22"] CGColor],
                           (id)[[self colorWithHexString:@"32a7eb"] CGColor],
                           nil]];
        [_grain setLocations:@[@0, @0.3, @0.7, @1]];
        [_grain setStartPoint:CGPointMake(0, 0)];
        [_grain setEndPoint:CGPointMake(1, 0)];
        _grain.type = kCAGradientLayerAxial;
        [self.layer addSublayer:_grain];
	}
	return _grain;
}
#pragma mark - 方法 Methods
//色值转换成颜色
- (UIColor *)colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


@end
