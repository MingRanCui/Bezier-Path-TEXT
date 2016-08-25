//
//  DrawView.m
//  Bezier Path TEXT
//
//  Created by 崔明燃 on 15/12/11.
//  Copyright © 2015年 崔明燃. All rights reserved.
//

#import "DrawView.h"

#define   DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)

static NSString * const kName = @"name";

static CGFloat const kRadius = 30;
static CGFloat const kLineWidth = 3;
static CGFloat const kStep1Duration = 1.0;
static CGFloat const kStep2Duration = 0.5;

@interface DrawView ()

@property (strong, nonatomic) CAShapeLayer *lin1;
@property (strong, nonatomic) CAShapeLayer *lin2;

@end

@implementation DrawView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = .5;
    }
    
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 10.0;
    // 添加路径[1条点(100,100)到点(200,100)的线段]到path
    [path moveToPoint:CGPointMake(100 , 100)];
    [path addLineToPoint:CGPointMake(200, 100)];
    // 将path绘制出来
}

#pragma mark - public
- (void)startAnimation {
    [self reset];
    [self doStep1];
}

#pragma mark - animation
- (void)reset {
    [self.arcLayer removeFromSuperlayer];
    [self.lin1 removeFromSuperlayer];
}

// 第一阶段
- (void)doStep1 {
    self.arcLayer = [ArcLayer layer];
    self.arcLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:self.arcLayer];
    
    self.arcLayer.bounds = CGRectMake(0, 0, kRadius * 2 + kLineWidth, kRadius * 2 + kLineWidth);
    self.arcLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // animation
    self.arcLayer.progress = 1; // end status
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
    animation.duration = kStep1Duration;
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    animation.delegate = self;
    [animation setValue:@"step1" forKey:kName];
    [self.arcLayer addAnimation:animation forKey:nil];
}
// 2阶段
- (void)doStep2 {
    self.lin1 = [CAShapeLayer layer];
    [self.layer addSublayer:self.lin1];
    self.lin1.frame = self.layer.bounds;
    // path
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    path.lineCapStyle = kCGLineCapSquare; //线条拐角
    path.lineJoinStyle = kCGLineCapRound; //终点处理
    
    [path moveToPoint:CGPointMake(CGRectGetMidX(self.bounds) - kRadius + 5, CGRectGetMidY(self.bounds))];
    [path addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds) - kRadius / 5, CGRectGetMidY(self.bounds) + kRadius / 5 * 2)];
    [path addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds) + kRadius - kRadius / 8 * 3, CGRectGetMidY(self.bounds) - kRadius / 2)];
    
    self.lin1.path = path.CGPath;
    self.lin1.lineWidth = kLineWidth;
    self.lin1.strokeColor = [UIColor colorWithRed:1 / 255.0 green:174 / 255.0 blue:159 / 255.0 alpha:1.0].CGColor;
    self.lin1.fillColor = nil;
    
    //SS(strokeStart)
    CGFloat SSFrom = 0;
    CGFloat SSTo = 1.0;
    // animation
    CABasicAnimation *startAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startAnimation.fromValue = @(SSFrom);
    startAnimation.toValue = @(SSTo);
    
    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimation.fromValue = @(SSFrom);
    endAnimation.toValue = @(SSTo);

    
    CAAnimationGroup *step2 = [CAAnimationGroup animation];
    step2.animations = @[endAnimation];
    step2.duration = kStep2Duration;
    step2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [self.lin1 addAnimation:step2 forKey:nil];
}

// 第2阶段
- (void)doStep_2 {
    self.moveArcLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.moveArcLayer];
    self.moveArcLayer.frame = self.layer.bounds;
    // 弧的path
    UIBezierPath *moveArcPath = [UIBezierPath bezierPath];
    // 小圆圆心
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    // d（x轴上弧圆心与小圆左边缘的距离）
    CGFloat d = kRadius / 2;
    // 弧圆心
    CGPoint arcCenter = CGPointMake(center.x - kRadius - d, center.y);
    // 弧半径
    CGFloat arcRadius = kRadius * 2 + d;
    // O(origin)
    CGFloat origin = M_PI * 2;
    // D(dest)
    CGFloat dest = M_PI * 2 - asin(kRadius * 2 / arcRadius);
    [moveArcPath addArcWithCenter:arcCenter radius:arcRadius startAngle:origin endAngle:dest clockwise:NO];
    
    self.moveArcLayer.path = moveArcPath.CGPath;
    self.moveArcLayer.lineWidth = 6;
    self.moveArcLayer.strokeColor = [UIColor colorWithRed:1 / 255.0 green:174 / 255.0 blue:159 / 255.0 alpha:1.0].CGColor;
    self.moveArcLayer.fillColor = nil;
    
    // SS(strokeStart)
    CGFloat SSFrom = 0;
    CGFloat SSTo = 0.9;
    
    // SE(strokeEnd)
    CGFloat SEFrom = 0.1;
    CGFloat SETo = 1;
    
    // end status
    self.moveArcLayer.strokeStart = SSTo;
    self.moveArcLayer.strokeEnd = SETo;
    
    // animation
    CABasicAnimation *startAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startAnimation.fromValue = @(SSFrom);
    startAnimation.toValue = @(SSTo);
    
    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimation.fromValue = @(SEFrom);
    endAnimation.toValue = @(SETo);
    
    CAAnimationGroup *step2 = [CAAnimationGroup animation];
    step2.animations = @[startAnimation, endAnimation];
    step2.duration = kStep2Duration;
    step2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [self.moveArcLayer addAnimation:step2 forKey:nil];
}

#pragma mark - animation step stop
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:kName] isEqualToString:@"step1"]) {
        [self doStep2];
    }
}

//
- (void)drawAnimation {
    self.arcLayer.progress = 1; // end status
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
    animation.duration = 3;
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    [self.arcLayer addAnimation:animation forKey:nil];
}


- (UIBezierPath*)createArcPath {
    UIBezierPath* aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(150, 150)
                                                         radius:75
                                                     startAngle:0
                                                       endAngle:DEGREES_TO_RADIANS(360)
                                                      clockwise:YES];
    aPath.lineWidth = 5.0;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    UIColor *color = [UIColor colorWithRed:1 / 255.0 green:174 / 255.0 blue:159 / 255.0 alpha:1.0];
    
    [color set];
    [aPath stroke];
    return aPath;
}

- (UIBezierPath*)creatOval {
    UIColor *color = [UIColor redColor];
    [color set]; //设置线条颜色
    
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    
    aPath.lineWidth = 5.0;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    
    [aPath moveToPoint:CGPointMake(20, 100)];
    
    [aPath addQuadCurveToPoint:CGPointMake(120, 100) controlPoint:CGPointMake(70, 0)];
    
    [aPath stroke];
    
    return aPath;
}

- (UIBezierPath*)creatOvalLine {
    UIColor *color = [UIColor redColor];
    [color set]; //设置线条颜色
    
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    
    aPath.lineWidth = 5.0;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    
    [aPath moveToPoint:CGPointMake(20, 50)];
    
    [aPath addCurveToPoint:CGPointMake(200, 50) controlPoint1:CGPointMake(110, 0) controlPoint2:CGPointMake(110, 100)];
    
    [aPath stroke];
    
    return aPath;
}

@end
