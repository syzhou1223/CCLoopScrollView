//
//  CCViewController.m
//  CCLoopScrollView
//
//  Created by zhoushaoyou on 04/15/2019.
//  Copyright (c) 2019 zhoushaoyou. All rights reserved.
//

#import "CCViewController.h"
#import "CCLoopScrollView.h"
#import "CCBannerView.h"

@interface CCViewController () <CCLoopScrollViewDelegate> {
    NSArray *_colors;
}

@end

@implementation CCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"CCLoopScrollView";
    
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

    
    _colors = @[[UIColor redColor],[UIColor greenColor],[UIColor blueColor],[UIColor yellowColor],[UIColor purpleColor],[UIColor grayColor],[UIColor cyanColor],[UIColor magentaColor],[UIColor brownColor],[UIColor orangeColor]];
    
    [loopScrollViewTop reloadData];
    [loopScrollViewMiddel reloadData];
    [loopScrollViewBottom reloadData];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to
{
    return from + (arc4random() % (to - from + 1));
}

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

@end
