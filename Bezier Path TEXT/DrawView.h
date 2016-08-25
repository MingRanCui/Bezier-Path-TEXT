//
//  DrawView.h
//  Bezier Path TEXT
//
//  Created by 崔明燃 on 15/12/11.
//  Copyright © 2015年 崔明燃. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcLayer.h"

@interface DrawView : UIView

@property (strong, nonatomic) ArcLayer *arcLayer;
@property (strong, nonatomic) CAShapeLayer *moveArcLayer;

- (void)startAnimation;

@end
