//
//  CCLoopScrollView.h
//  CCLoopScrollView_Example
//
//  Created by syzhou on 2019/4/15.
//  Copyright © 2019 zhoushaoyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCLoopScrollView;
@protocol CCLoopScrollViewDelegate <NSObject>

@required;
/**
 指定数据源的个数，必须实现
 
 @param loopScrollView loopScrollView
 @return 数据源的个数
 */
- (NSInteger)numberOfPageInLoopScrollView:(CCLoopScrollView *)loopScrollView;


/**
 自定义每个页面的UI，调用方法dequeueReusableViewWithPosition:获取缓存的View，
 如果为空，需要新建一个View,必须实现
 
 @param loopScrollView loopScrollView
 @param index 页面的数据源序号，用于取指定的数据来绘制UI
 @param position 页面的位置，用于调用dequeueReusableViewWithPosition：方法获取缓存的View
 @return 自定义每个页页的View
 */
- (UIView *)loopScrollView:(CCLoopScrollView *)loopScrollView viewForPageAtIndex:(NSInteger)index withPosition:(NSInteger)position;

@optional;

/**
 页面的点击事件
 
 @param loopScrollView loopScrollView
 @param index 点击页面的序号
 */
- (void)loopScrollView:(CCLoopScrollView *)loopScrollView didSelectedPageAtIndex:(NSInteger)index;


/**
 跳转到第几页回调
 
 @param loopScrollView loopScrollView
 @param page 第几页
 */
- (void)loopScrollView:(CCLoopScrollView *)loopScrollView moveToPage:(NSInteger)page;

@end

@interface CCLoopScrollView : UIView

@property (nonatomic, weak) id <CCLoopScrollViewDelegate> delegate;

/* 自动滚动时间，默认为0，不滚动；*/
@property (nonatomic, assign) CGFloat autoScrollDelay;

/* Default is UIEdgeInsetsZero */
@property (nonatomic, assign) UIEdgeInsets contentEdgeInset;

/* Default is UIEdgeInsetsZero */
@property (nonatomic, assign) UIEdgeInsets pageViewEdgeInset;

/* 当前页码，从0开始 */
@property (readonly, assign) NSInteger currentIndex;

/* 自动滚动时的动画 默认为 kCAMediaTimingFunctionDefault */
@property (nonatomic, copy) CAMediaTimingFunctionName autoScrollAnimationType;

/* 自动滚动时的时间 默认为 0.8s */
@property (nonatomic, assign) CGFloat autoScrollAnimationDuration;

/**
 同时存在内存中的PageView数量，默认为 3，可以设置为5、7、9等。
 一般情况下，3个页面就能满足需求了，一些特别的UI需求，自定义contentEdgeInset时，需要设置更多的缓存页面来达到无缝滑动的效果。
 */
@property (nonatomic, assign) int maxPageViewCounts;


/**
 * 刷新界面
 */
- (void)reloadData;


/**
 根据位置取出缓存中的View
 
 @param position 位置，从协议loopScrollView:viewForPageAtIndex:withPosition中获得
 @return pageview，如果为空，需要自定义生成
 */
- (UIView *)dequeueReusableViewWithPosition:(NSInteger)position;

/**
 * 停止自动滚动
 */
- (void)stopAutoScroll;

/**
 * 开始自动滚动，如果支持
 */
- (void)startAutoScrollIfNeed;


@end
