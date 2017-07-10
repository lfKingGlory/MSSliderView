//
//  MSScrollView.m
//  MSSliderView
//
//  Created by msj on 2017/7/10.
//  Copyright © 2017年 msj. All rights reserved.
//

#import "MSScrollView.h"
#import "UIView+FrameUtil.h"

#define RGB(r,g,b)      [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@interface MSContentView : UIView
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation MSContentView
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageView = [UIImageView new];
        [self addSubview:self.imageView];
        self.imageView.backgroundColor = RGB(arc4random() % 255 + 1, arc4random() % 255 + 1, arc4random() % 255 + 1);
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.imageView.frame = CGRectMake(10, 10, self.width - 20, self.height - 20);
}
@end

@interface MSScrollView ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;

@property (assign, nonatomic) CGFloat topMargin;
@property (assign, nonatomic) CGFloat leftMargin;
@property (assign, nonatomic) CGFloat minAlpha;

@property (strong, nonatomic) NSMutableArray *contentViewArray;
@end

@implementation MSScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentViewArray = [NSMutableArray array];
        
        self.clipsToBounds = YES;
        
        self.leftMargin = 40;
        self.topMargin = 10;
        
        self.minAlpha = 0.1;
        
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
    
    if (self.contentViewArray && self.contentViewArray.count > 0) {
        [self.contentViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.contentViewArray removeAllObjects];
    }
    
    self.scrollView.contentOffset = CGPointZero;
    
    CGFloat scrollViewW = self.width - self.leftMargin * 2;
    CGFloat scrollViewH = self.height - self.topMargin * 2;
    CGFloat scrollViewX = self.leftMargin;
    CGFloat scrollViewY = self.topMargin;
    self.scrollView.contentSize = CGSizeMake(count * scrollViewW, 0);
    self.scrollView.frame = CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH);
    
    for (int i = 0; i < count; i++) {
        
        MSContentView *contentView = [[MSContentView alloc] init];
        contentView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:contentView];
        [self.contentViewArray addObject:contentView];
        
        CGFloat offsetRatio = [self getOffsetRatioWith:scrollViewW * i contentOffsetX:self.scrollView.contentOffset.x];
        CGFloat height = fmax(self.scrollView.height * (1-offsetRatio), self.scrollView.height * 0.8);

        contentView.frame = CGRectMake(scrollViewW * i, (self.scrollView.height - height)/2.0, scrollViewW, height);
        contentView.alpha = fmax(1 * (1-offsetRatio), self.minAlpha);
    }
    
    if (self.block) {
        self.block(0);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    NSInteger count  = contentOffsetX / scrollView.width + 0.5;
    count = MIN(count, self.contentViewArray.count - 1);
    
    if (self.block) {
        self.block(count);
    }
    
    for (int i = 0;  i < self.contentViewArray.count; i++) {
        
        UILabel *contentView = self.contentViewArray[i];
        CGFloat offsetRatio = [self getOffsetRatioWith:contentView.x contentOffsetX:contentOffsetX];
        CGFloat height = fmax(self.scrollView.height * (1-offsetRatio), self.scrollView.height * 0.8);
        
        contentView.frame = CGRectMake(contentView.x, (self.scrollView.height - height)/2.0, contentView.width, height);
        contentView.alpha = fmax(1 * (1-offsetRatio), self.minAlpha);
    }
}

- (CGFloat)getOffsetRatioWith:(CGFloat)x contentOffsetX:(CGFloat)contentOffsetX {
    CGFloat distanceFromCenterX = x - contentOffsetX;
    CGFloat offsetRatio = fabs(distanceFromCenterX) / self.width;
    return fmin(offsetRatio, 1);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isEqual:self]) {
        for (UIView *subview in self.contentViewArray) {
            
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
