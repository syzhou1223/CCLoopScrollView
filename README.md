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
loopScrollViewTop.autoScrollAnimationDuration = 0.3;
[self.view addSubview:loopScrollViewTop];

CCLoopScrollView *loopScrollViewMiddel = [[CCLoopScrollView alloc] initWithFrame:CGRectMake(0, loopScrollViewTop.frame.size.height + loopScrollViewTop.frame.origin.y + 20, self.view.frame.size.width, 100)];
loopScrollViewMiddel.delegate = self;
loopScrollViewMiddel.contentEdgeInset = UIEdgeInsetsMake(0, 15, 0, 15);
loopScrollViewMiddel.pageViewEdgeInset = UIEdgeInsetsMake(0, 5, 0, 5);
loopScrollViewMiddel.autoScrollAnimationType = kCAMediaTimingFunctionEaseOut;
loopScrollViewMiddel.autoScrollDelay = 2.0;
[self.view addSubview:loopScrollViewMiddel];

CCLoopScrollView *loopScrollViewBottom = [[CCLoopScrollView alloc] initWithFrame:CGRectMake(0, loopScrollViewMiddel.frame.size.height + loopScrollViewMiddel.frame.origin.y + 20, self.view.frame.size.width, 100)];
loopScrollViewBottom.delegate = self;
loopScrollViewBottom.contentEdgeInset = UIEdgeInsetsMake(0, 15, 0, 15);
loopScrollViewBottom.pageViewEdgeInset = UIEdgeInsetsMake(0, 5, 0, 5);
loopScrollViewBottom.autoScrollAnimationType = kCAMediaTimingFunctionEaseOut;
loopScrollViewBottom.autoScrollDelay = 2.0;
loopScrollViewBottom.maxPageViewCounts = 5;
[self.view addSubview:loopScrollViewBottom];
```


## Author

zhoushaoyou, zhouxbbbj1@126.com

## License

CCLoopScrollView is available under the MIT license. See the LICENSE file for more info.
