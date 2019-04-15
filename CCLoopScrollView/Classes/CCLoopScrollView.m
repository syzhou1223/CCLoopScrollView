//
//  CCLoopScrollView.m
//  CCLoopScrollView_Example
//
//  Created by syzhou on 2019/4/15.
//  Copyright © 2019 zhoushaoyou. All rights reserved.
//
#import "CCLoopScrollView.h"

#define  CenterPageViewTag 1000

@interface CCLoopScrollView () <UIScrollViewDelegate,CAAnimationDelegate> {
    UIScrollView *_scrollView;
    CABasicAnimation *_autoScrollAnimation;
    NSTimer *_autoScrollTimer;
    NSInteger _dataSourceCount;
}

@end


@implementation CCLoopScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.clipsToBounds = false;
        [self addSubview:_scrollView];
        
        _currentIndex = 0;
        _autoScrollDelay = 0.0;
        _maxPageViewCounts = 3;
        _autoScrollAnimationType = kCAMediaTimingFunctionDefault;
        _autoScrollAnimationDuration = 0.8;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInside)];
        [_scrollView addGestureRecognizer:tap];
        
        
    }
    
    return self;
}

-(void)dealloc {
    [self removeTimer];
}

- (void)setContentEdgeInset:(UIEdgeInsets)cotentEdgeInset {
    _contentEdgeInset = cotentEdgeInset;
    
    _scrollView.frame = CGRectMake(cotentEdgeInset.left, cotentEdgeInset.top, self.frame.size.width - cotentEdgeInset.left - cotentEdgeInset.right, self.frame.size.height - cotentEdgeInset.top - cotentEdgeInset.bottom);
}

- (void)setMaxPageViewCounts:(int)maxPageCounts {
    _maxPageViewCounts = maxPageCounts;
    
    if (maxPageCounts <= 3) {
        _maxPageViewCounts = 3;
    } else if (maxPageCounts % 2 == 0){
        //保证为数量为奇数
        _maxPageViewCounts++;
    }
}

- (void)tapInside {
    if ([_delegate respondsToSelector:@selector(loopScrollView:didSelectedPageAtIndex:)]) {
        [_delegate loopScrollView:self didSelectedPageAtIndex:_currentIndex];
    }
}

/**
 * 刷新界面
 */
- (void)reloadData {
    [self removeTimer];
    [self clearView];
    
    if ([_delegate respondsToSelector:@selector(numberOfPageInLoopScrollView:)]) {
        _dataSourceCount = [_delegate numberOfPageInLoopScrollView:self];
    }
    
    if (_dataSourceCount == 1) {//只有一页
        if ([_delegate respondsToSelector:@selector(loopScrollView:viewForPageAtIndex:withPosition:)]) {
            UIView *pageView = [_delegate loopScrollView:self viewForPageAtIndex:0 withPosition:0];
            if (!pageView.superview) {
                pageView.tag = [self getPageViewTagWithPosition:0];
                pageView.frame = CGRectMake(0, 0,_scrollView.frame.size.width, _scrollView.frame.size.height);
                [_scrollView addSubview:pageView];
                
            }
            _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height);
            [_scrollView setContentOffset:CGPointMake(0, 0)];
            
            if ([_delegate respondsToSelector:@selector(loopScrollView:moveToPage:)]) {
                [_delegate loopScrollView:self moveToPage:0];
            }
        }
    } else if (_dataSourceCount > 1) {
        [self reloadPageViews];
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * _maxPageViewCounts, _scrollView.frame.size.height);
        
        _currentIndex = 0;
        [self setUpTimer];
        if ([_delegate respondsToSelector:@selector(loopScrollView:moveToPage:)]) {
            [_delegate loopScrollView:self moveToPage:0];
        }
    }
}

/**
 调整当前页
 
 @param offsetX scrollview content offset
 */
- (void)resetCurrentPageWithOffset:(CGFloat)offsetX {
    NSInteger  curPage = _currentIndex;
    
    CGFloat middelPosition = _scrollView.frame.size.width * (_maxPageViewCounts / 2);
    CGFloat moveDistance = offsetX - middelPosition;
    
    if (moveDistance > 0 && moveDistance >= _scrollView.frame.size.width) {
        //右滑
        curPage++;
        if (curPage >= _dataSourceCount) {
            curPage = 0;
        }
        
    } else if (moveDistance < 0 && moveDistance <= -_scrollView.frame.size.width) {
        //左滑
        curPage--;
        if (curPage <= -1) {
            curPage = _dataSourceCount-1;
        }
    }
    
    if (curPage != _currentIndex) {
        //滑过了一页刷新视图
        _currentIndex = curPage;
        
        
        [self reloadPageViews];
        if ([_delegate respondsToSelector:@selector(loopScrollView:moveToPage:)]) {
            [_delegate loopScrollView:self moveToPage:_currentIndex];
        }
    }
}




/**
 刷新视图
 */
- (void)reloadPageViews {
    for (NSInteger position = -_maxPageViewCounts / 2 ; position <= _maxPageViewCounts / 2; position++) {
        NSInteger pageIndex = [self getPageIndexWithPosition:position];
        UIView *pageView = [_delegate loopScrollView:self viewForPageAtIndex:pageIndex withPosition:position];
        if (!pageView.superview) {
            pageView.tag = [self getPageViewTagWithPosition:position];
            [_scrollView addSubview:pageView];
        }
        pageView.frame = CGRectMake(_scrollView.frame.size.width * (position + _maxPageViewCounts / 2) + self.pageViewEdgeInset.left, self.pageViewEdgeInset.top,_scrollView.frame.size.width - self.pageViewEdgeInset.left - self.pageViewEdgeInset.right, _scrollView.frame.size.height - self.pageViewEdgeInset.top - self.pageViewEdgeInset.bottom);
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * (_maxPageViewCounts / 2), 0)];
    
}


/**
 根据位置取出缓存中的View
 
 @param position 位置，从协议loopScrollView:viewForPageAtIndex:withPosition中获得
 @return pageview，如果为空，需要自定义生成
 */
- (UIView *)dequeueReusableViewWithPosition:(NSInteger)position {
    return [_scrollView viewWithTag:[self getPageViewTagWithPosition:position]];
}



/**
 根据位置获取视图的tag
 
 @param position 位置
 @return tag
 */
- (NSInteger)getPageViewTagWithPosition:(NSInteger)position {
    return CenterPageViewTag + position;
}


/**
 根据视图位置获取数据源序号
 
 @param position 当前页在scrollview中的位置
 @return 当前页在数据源中的序号
 */
- (NSInteger)getPageIndexWithPosition:(NSInteger)position {
    NSInteger pageIndex = _currentIndex + position;
    if (pageIndex < 0) {
        pageIndex = _dataSourceCount + pageIndex;
    } else if (pageIndex >= _dataSourceCount) {
        pageIndex = pageIndex - _dataSourceCount;
    }
    
    return pageIndex;
}

- (void)clearView {
    [_scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}

#pragma mark - 自动滚动
- (void)setAutoScrollDelay:(CGFloat)autoScrollDelay {
    _autoScrollDelay = autoScrollDelay;
    
    if (_autoScrollDelay > 0 && _dataSourceCount > 1) {
        [self setUpTimer];
    } else {
        [self removeTimer];
    }
}


/**
 设置定时器
 */
- (void)setUpTimer {
    if (_autoScrollTimer) {
        [self removeTimer];
    }
    
    if (_autoScrollDelay > 0) {
        //初始化滑动动画
        if (!_autoScrollAnimation) {
            CGRect toBounds = _scrollView.bounds;
            toBounds.origin.x = (_maxPageViewCounts / 2 + 1) * _scrollView.frame.size.width;
            _autoScrollAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
            _autoScrollAnimation.duration = _autoScrollAnimationDuration;
            _autoScrollAnimation.timingFunction = [CAMediaTimingFunction functionWithName:_autoScrollAnimationType];
            _autoScrollAnimation.fromValue = [NSValue valueWithCGRect:_scrollView.bounds];
            _autoScrollAnimation.toValue = [NSValue valueWithCGRect:toBounds];
            _autoScrollAnimation.removedOnCompletion = YES;
            _autoScrollAnimation.delegate = self;
        }
        
        _autoScrollTimer = [NSTimer timerWithTimeInterval:_autoScrollDelay target:self selector:@selector(scorllToNextPage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_autoScrollTimer forMode:NSRunLoopCommonModes];
        
    }
}


/**
 移除定时器
 */
- (void)removeTimer {
    if (_autoScrollTimer == nil) return;
    if (_autoScrollTimer.valid) {
        [_autoScrollTimer invalidate];
        _autoScrollTimer = nil;
    }
}

- (void)scorllToNextPage {
    if (_dataSourceCount <= 1) {
        [self removeTimer];
    } else {
        
        CGRect bounds = _scrollView.bounds;
        bounds.origin.x = (_maxPageViewCounts / 2 + 1) * _scrollView.frame.size.width;
        [_scrollView.layer addAnimation:_autoScrollAnimation forKey:@"bounds"];
        _scrollView.bounds = bounds;
        
    }
}


/**
 * 停止自动滚动
 */
- (void)stopAutoScroll {
    [self removeTimer];
}

/**
 * 开始自动滚动，如果支持
 */
- (void)startAutoScrollIfNeed {
    if (_autoScrollDelay > 0 ) {
        [self setUpTimer];
    }
}




#pragma mark - CAAnimation Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    //调整页面
    [self resetCurrentPageWithOffset:_scrollView.contentOffset.x];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self setUpTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self resetCurrentPageWithOffset:scrollView.contentOffset.x];
}


@end
