//
//  FUDRefreshHeader.m
//  FUDRefresh
//
//  Created by fudo on 2017/6/30.
//  Copyright © 2017年 fudo. All rights reserved.
//

#import "FUDRefreshHeader.h"

const CGFloat FUDHeaderWidth = 100.0;
const CGFloat FUDHeaderHeight = 40.0;

const CGFloat FUDHeaderPullLen = 80;     // 需要下拉的距离
const CGFloat FUDHeaderFreshLen = 60;
const NSInteger FUDRefreshTimeout = 10;   // 刷新超时

@interface FUDRefreshHeader ()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel      *statusLabel;
@property (nonatomic, assign) CGFloat      progress;
@property (nonatomic, strong) NSTimer      *timer;
@property (nonatomic, assign) BOOL         isRefreshing;

@end

@implementation FUDRefreshHeader

- (instancetype)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, FUDHeaderWidth, FUDHeaderHeight)]) {
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -(FUDHeaderHeight+(FUDHeaderPullLen-FUDHeaderHeight)/2), FUDHeaderWidth, FUDHeaderHeight)];
        [self addSubview:self.statusLabel];
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) {
        self.scrollView = (UIScrollView *)newSuperview;
        self.center = CGPointMake(self.scrollView.center.x, self.center.y);
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    } else {
        // self从superview移除的时候
        [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        self.progress = - self.scrollView.contentOffset.y;
    }
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    if (!self.isRefreshing) {
        if (progress > 0 && progress < FUDHeaderPullLen) {
            [self.statusLabel setText:@"继续下拉"];
        } else if (progress >= FUDHeaderPullLen) {
            [self.statusLabel setText:@"松开刷新"];
        }
        
        if (!self.scrollView.dragging && progress>=FUDHeaderFreshLen) {
            [self startRefresh];
        }
    } else {
        [self.statusLabel setText:@"正在刷新"];
    }
    
}

- (void)startRefresh {
    _isRefreshing = YES;
    NSLog(@"%@, 开始刷新", [self class]);
    UIEdgeInsets insets = self.scrollView.contentInset;
    insets.top += FUDHeaderPullLen;
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentInset = insets;
    } completion:^(BOOL finished) {
        if (self.refreshHandle) {
            self.refreshHandle();
        }
    }];
    
    [self startTimer];
}

- (void)stopRefresh {
    _isRefreshing = NO;
    NSLog(@"%@, 刷新完成", [self class]);
    [self stopTimer];
    UIEdgeInsets insets = self.scrollView.contentInset;
    insets.top -= FUDHeaderPullLen;
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentInset = insets;
    }];
}

- (void)startTimer {
    __weak typeof(self)weakSelf = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:FUDRefreshTimeout repeats:NO block:^(NSTimer * _Nonnull timer) {
        [weakSelf stopRefresh];
    }];
}

- (void)stopTimer {
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)dealloc {
    [self stopTimer];
    
    NSLog(@"****** %@ dealloc ******", [self class]);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
