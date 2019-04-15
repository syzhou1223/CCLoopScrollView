# CCLoopScrollView

[![CI Status](https://img.shields.io/travis/zhoushaoyou/CCLoopScrollView.svg?style=flat)](https://travis-ci.org/zhoushaoyou/CCLoopScrollView)
[![Version](https://img.shields.io/cocoapods/v/CCLoopScrollView.svg?style=flat)](https://cocoapods.org/pods/CCLoopScrollView)
[![License](https://img.shields.io/cocoapods/l/CCLoopScrollView.svg?style=flat)](https://cocoapods.org/pods/CCLoopScrollView)
[![Platform](https://img.shields.io/cocoapods/p/CCLoopScrollView.svg?style=flat)](https://cocoapods.org/pods/CCLoopScrollView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

CCLoopScrollView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CCLoopScrollView'
```

## 运行效果
![siri](https://github.com/syzhou1223/CCLoopScrollView/blob/master/Example/CCLoopScrollView/screenshot.gif)

## 使用示例
```Objective-C
CCLoopScrollView *loopScrollViewTop = [[CCLoopScrollView alloc] initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, 100)];
loopScrollViewTop.delegate = self;
loopScrollViewTop.autoScrollDelay = 2.0;
[self.view addSubview:loopScrollViewTop];

#pragma mark - CCLoopScrollView Delegate
- (NSInteger)numberOfPageInLoopScrollView:(CCLoopScrollView *)loopScrollView {
    return [self getRandomNumber:1 to:_colors.count];
}

- (UIView *)loopScrollView:(CCLoopScrollView *)loopScrollView viewForPageAtIndex:(NSInteger)index withPosition:(NSInteger)position {
    CCBannerView *pageView = (CCBannerView *)[loopScrollView dequeueReusableViewWithPosition:position];
    if (!pageView) {
        pageView = [[CCBannerView alloc] initWithFrame:loopScrollView.bounds];
    }
    
    [pageView setTitle:[NSString stringWithFormat:@"第 %ld 页",index + 1]];
    
    if (index < _colors.count) {
        [pageView setBackgroundColor:[_colors objectAtIndex:index]];
    }
    
    
    return pageView;
}

```


## Author

zhoushaoyou, zhouxbbbj1@126.com

## License

CCLoopScrollView is available under the MIT license. See the LICENSE file for more info.
