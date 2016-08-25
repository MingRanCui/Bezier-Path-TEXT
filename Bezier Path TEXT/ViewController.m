//
//  ViewController.m
//  Bezier Path TEXT
//
//  Created by 崔明燃 on 15/12/11.
//  Copyright © 2015年 崔明燃. All rights reserved.
//

#import "ViewController.h"
#import "DrawView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *buton1;
@property (strong, nonatomic) DrawView *drawBegin;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _drawBegin = [[DrawView alloc] initWithFrame:(CGRect){0, 100, self.view.frame.size.width, 300}];
    [self.view addSubview:_drawBegin];
}

- (void)draw {
}
- (IBAction)animationBegin:(id)sender {
    [self.drawBegin startAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end