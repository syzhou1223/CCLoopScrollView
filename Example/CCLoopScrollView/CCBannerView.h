//
//  CCBannerView.h
//  CCLoopScrollView_Example
//
//  Created by syzhou on 2019/4/15.
//  Copyright © 2019 zhoushaoyou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface CCBannerView : UIView  {
    UIImageView *_posterImgv;
    UILabel *_titleLabel;
}

/**
 * 设置Banner图片url
 */
- (void)setPosterUrl:(NSString *)url;

/**
 * @desc 设计banner标题
 */
- (void)setTitle:(NSString *)title;

- (void)setPoster:(UIImage *)img;



@end


NS_ASSUME_NONNULL_END
