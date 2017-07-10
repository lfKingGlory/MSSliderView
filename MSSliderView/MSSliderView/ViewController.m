//
//  ViewController.m
//  MSSliderView
//
//  Created by msj on 2017/7/6.
//  Copyright © 2017年 msj. All rights reserved.
//

#import "ViewController.h"
#import "MSSliderView.h"
#import "UIView+FrameUtil.h"

@interface ViewController ()
@property (strong, nonatomic) MSSliderView *sliderView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    MSSliderView *sliderView = [[MSSliderView alloc] initWithFrame:CGRectMake(30, 100, self.view.width - 60, 50)];
    sliderView.block = ^(NSInteger currentIndex) {
        NSLog(@"currentIndex=============%ld",currentIndex);
    };
    [self.view addSubview:sliderView];
    sliderView.count = 10;
    self.sliderView = sliderView;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.sliderView.count = arc4random() % 20;
    
}

@end
