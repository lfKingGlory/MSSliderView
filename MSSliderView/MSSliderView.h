//
//  MSSliderView.h
//  MSSliderView
//
//  Created by msj on 2017/7/6.
//  Copyright © 2017年 msj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSSliderView : UIView
@property (assign, nonatomic) NSInteger count;
@property (copy, nonatomic) void (^block)(NSInteger currentIndex);
@end
