//
//  ArcLayer.m
//  Bezier Path TEXT
//
//  Created by 崔明燃 on 15/12/11.
//  Copyright © 2015年 崔明燃. All rights reserved.
//

#import "ArcLayer.h"

static CGFloat const kLineWidth = 3;

@interface ArcLayer ()

@property (strong, nonatomic) CAShapeLayer *line1;

@end

@implementation ArcLayer
@dynamic progress;

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"progress"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat kRadius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2 - kLineWidth / 2;
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    // 0
    CGFloat originStart = M_PI * 3;
    CGFloat originEnd = M_PI * 3;
    CGFloat currentOrigin = originStart - (originStart - originEnd) * self.progress;
    
    // D
    CGFloat destStart = M_PI * 3;
    CGFloat destEnd = 0;
    CGFloat currentDest = destStart - (destStart - destEnd) * self.progress;
    
    [path addArcWithCenter:center radius:kRadius startAngle:currentOrigin endAngle:currentDest clockwise:NO];
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetLineWidth(ctx, kLineWidth);
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:1 / 255.0 green:174 / 255.0 blue:159 / 255.0 alpha:1.0].CGColor);
    CGContextStrokePath(ctx);
}

@end
