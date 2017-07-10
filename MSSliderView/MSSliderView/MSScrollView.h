//
//  MSScrollView.h
//  MSSliderView
//
//  Created by msj on 2017/7/10.
//  Copyright © 2017年 msj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSScrollView : UIView
@property (assign, nonatomic) NSInteger count;
@property (copy, nonatomic) void (^block)(NSInteger currentIndex);
@end
