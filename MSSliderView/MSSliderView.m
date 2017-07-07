//
//  MSSliderView.m
//  MSSliderView
//
//  Created by msj on 2017/7/6.
//  Copyright © 2017年 msj. All rights reserved.
//

#import "MSSliderView.h"
#import "UIView+FrameUtil.h"

#define MAINCOLOR [UIColor colorWithRed:235/255.0 green:99/255.0 blue:43/255.0 alpha:1]
#define SECONDCOLOR [UIColor colorWithWhite:0.5 alpha:1]

@interface MSSliderView ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) CGFloat maxFont;
@property (assign, nonatomic) CGFloat minFont;
@property (assign, nonatomic) CGFloat secondAlpha;
@property (assign, nonatomic) CGFloat thirdAlpha;
@end

@implementation MSSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
        self.clipsToBounds = YES;
        
        self.maxFont = 28;
        self.minFont = 15;
        
        self.secondAlpha = 0.4;
        self.thirdAlpha = 0.2;
    
        self.scrollView = [[UIScrollView alloc] init];
        [self addSubview:self.scrollView];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.alwaysBounceHorizontal = YES;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.clipsToBounds = NO;
        self.scrollView.delegate = self;
    }
    return self;
}

- (void)setCount:(NSInteger)count {
    
    CGFloat scrollViewW = 60;
    CGFloat scrollViewH = self.maxFont;
    CGFloat scrollViewX = (self.width - scrollViewW)/2.0;
    CGFloat scrollViewY = (self.height - self.maxFont)/2.0;
    self.scrollView.contentSize = CGSizeMake(count * scrollViewW, 0);
    self.scrollView.frame = CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH);
    
    for (int i = 0; i < count; i++) {
        UILabel *lbText = [[UILabel alloc] init];
        lbText.text = [NSString stringWithFormat:@"%d期",i+1];
        lbText.textAlignment = NSTextAlignmentCenter;
        [self.scrollView addSubview:lbText];
        
        if(i == 0) {
            
            lbText.font = [UIFont systemFontOfSize:self.maxFont];
            lbText.frame = CGRectMake(scrollViewW * i, self.scrollView.height - self.maxFont, scrollViewW, self.maxFont);
            lbText.textColor = MAINCOLOR;
            lbText.alpha = 1;
            
        } else if (i == 1){

            CGFloat offsetRatio = [self getOffsetRatioWith:scrollViewW * i contentOffsetX:self.scrollView.contentOffset.x];
            
            CGFloat font = fmax(self.maxFont * (1-offsetRatio), self.minFont);
            CGFloat height = font;
            
            lbText.font = [UIFont systemFontOfSize:font];
            lbText.frame = CGRectMake(scrollViewW * i, self.scrollView.height - height, scrollViewW, height);
            lbText.textColor = SECONDCOLOR;
            lbText.alpha = self.secondAlpha;
            
        } else {
            
            lbText.font = [UIFont systemFontOfSize:self.minFont];
            lbText.frame = CGRectMake(scrollViewW * i, self.scrollView.height - self.minFont, scrollViewW, self.minFont);
            lbText.textColor = SECONDCOLOR;
            lbText.alpha = self.thirdAlpha;
        }
    }
    
    if (self.block) {
        self.block(0);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    NSInteger count  = contentOffsetX / scrollView.width + 0.5;
    count = MIN(count, self.scrollView.subviews.count - 1);
    
    if (self.block) {
        self.block(count);
    }
    
    UILabel *lbCurrent = self.scrollView.subviews[count];
    CGFloat offsetRatio = [self getOffsetRatioWith:lbCurrent.x contentOffsetX:contentOffsetX];
    CGFloat alphaRatio = fmax(1 * (1-offsetRatio), self.thirdAlpha);
    lbCurrent.alpha = alphaRatio;
    lbCurrent.textColor = MAINCOLOR;

    for (int i = 0;  i < self.scrollView.subviews.count; i++) {
        
        UILabel *lbText = self.scrollView.subviews[i];
        CGFloat offsetRatio = [self getOffsetRatioWith:lbText.x contentOffsetX:contentOffsetX];
        CGFloat font = fmax(self.maxFont * (1-offsetRatio), self.minFont);
        CGFloat height = font;
        
        lbText.font = [UIFont systemFontOfSize:font];
        lbText.frame = CGRectMake(lbText.x, self.scrollView.height - height, lbText.width, height);
        
        if (i != count) {
            lbText.textColor = SECONDCOLOR;
            lbText.alpha = fmax(1 * (1-offsetRatio), self.thirdAlpha);
        }
        
    }
}

- (CGFloat)getOffsetRatioWith:(CGFloat)x contentOffsetX:(CGFloat)contentOffsetX {
    CGFloat distanceFromCenterX = x - contentOffsetX;
    CGFloat offsetRatio = fabs(distanceFromCenterX) / CGRectGetWidth(self.frame);
    offsetRatio = fmin(offsetRatio, 1);
    return offsetRatio;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isEqual:self]) {
        for (UIView *subview in self.scrollView.subviews) {
            
            CGFloat pointX = point.x - self.scrollView.x + self.scrollView.contentOffset.x - subview.x;
            CGFloat pointY = point.y - self.scrollView.y + self.scrollView.contentOffset.y - subview.y;
            CGPoint offset = CGPointMake(pointX, pointY);
            
            if ((view = [subview hitTest:offset withEvent:event])) {
                return view;
            }
        }
        return self.scrollView;
    }
    return view;
}

@end
