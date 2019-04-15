
//
//  CCBannerView.m
//  CCLoopScrollView_Example
//
//  Created by syzhou on 2019/4/15.
//  Copyright © 2019 zhoushaoyou. All rights reserved.
//

#import "CCBannerView.h"

@implementation CCBannerView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _posterImgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_posterImgv];
    }
    
    return self;
}

/**
 * 设置Banner图片url
 */
- (void)setPosterUrl:(NSString *)url {
    if (url) {
        ;
    }
}

/**
 * @desc 设计banner标题
 */
- (void)setTitle:(NSString *)title {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 40)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    _titleLabel.text = title;
}

- (void)setPoster:(UIImage *)img {
    
}

@end
