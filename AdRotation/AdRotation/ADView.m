//
//  ADView.m
//  OC
//
//  Created by 鲁曦广 on 16/7/8.
//  Copyright © 2016年 CIeNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADView.h"

typedef NS_ENUM(NSInteger, ViewInitType) {
    ViewInitTypeFrame,    //通过代码创建View
    ViewInitTypeNib       //通过nib创建View
};

@interface ADView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) NSTimer *timeAD;
@property (assign, nonatomic) CGFloat widthAD;
@property (assign, nonatomic) CGFloat heightAD;
@property (assign, nonatomic) NSInteger pageAD;
@property (strong, nonatomic) NSMutableArray *arrImageView;
@property (strong, nonatomic) UIScrollView *scrollViewAD;
@property (strong, nonatomic) UIPageControl *pageControlAD;
@property (strong, nonatomic) UIImageView *rightImageView;
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) NSLock *lockAD;
@property (assign, nonatomic) BOOL runThrough;
@property (assign, nonatomic) ViewInitType viewInitType;
@end

@implementation ADView
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self) {
        _viewInitType = ViewInitTypeNib;
        [self initWithViewFrame:CGRectMake(0, 0, 0, 0)];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        _viewInitType = ViewInitTypeFrame;
        [self initWithViewFrame:frame];
    }
    return self;
}

- (void)initWithViewFrame:(CGRect)frame{
    if (_viewInitType == ViewInitTypeNib) {
        _widthAD = SCRREENWIDTH;
        //若autolayout 按照宽高比布局则用下句
        _heightAD = SCRREENWIDTH*(self.frame.size.height/self.frame.size.width);
        //若固定高度布局
        //_heightAD = self.frame.size.height;
    }else{
        _widthAD = frame.size.width;
        _heightAD = frame.size.height;
    }
    _arrImageView =[NSMutableArray array];
    _scrollViewAD = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _widthAD, _heightAD)];
    _scrollViewAD.showsHorizontalScrollIndicator = NO;
    _scrollViewAD.showsVerticalScrollIndicator = NO;
    _scrollViewAD.pagingEnabled = YES;
    _scrollViewAD.delegate = self;
    _scrollViewAD.backgroundColor = [UIColor grayColor];
    [self addSubview:_scrollViewAD];
    _pageControlAD = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _heightAD-30, _widthAD, 30)];
    _pageControlAD.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    _pageControlAD.numberOfPages = 0;
    _pageControlAD.currentPage = 0;
    _pageControlAD.pageIndicatorTintColor = [UIColor redColor];
    _pageControlAD.currentPageIndicatorTintColor = [UIColor greenColor];
    [_pageControlAD addTarget:self action:@selector(pageVCTouch:) forControlEvents:UIControlEventValueChanged];  //用户点击UIPageControl的响应函数
    [self addSubview:_pageControlAD];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_lockAD lock];
    if (!_runThrough) {
        _runThrough = YES;
        [self removeTimeAD];
    }
    [_lockAD unlock];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollviewW =  scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    _pageAD = (x + scrollviewW / 2) /  scrollviewW;
    CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
    if (translatedPoint.x<0) {
        if (x>=_widthAD*_arrImagerURL.count){
            [_scrollViewAD setContentOffset:CGPointMake(0, 0) animated:NO];
        }
    }else{
        if (x<0) {
            [_scrollViewAD setContentOffset:CGPointMake(_widthAD*_arrImagerURL.count, 0) animated:NO];
        }
    }
    _pageControlAD.currentPage = _pageAD;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self addTimeAD];
    _runThrough = NO;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (_pageAD == _arrImagerURL.count) {
        self.scrollViewAD.contentOffset = CGPointMake(0, 0);
        _pageAD = 0;
    }
}

#pragma mark - set/get
- (void)setArrImagerURL:(NSMutableArray *)arrImagerURL{
    if (arrImagerURL.count == 0) {
        return;
    }
    if (_arrImagerURL == nil) {
        _arrImagerURL = [NSMutableArray array];
    }
    _arrImagerURL = arrImagerURL;
    _pageControlAD.numberOfPages = _arrImagerURL.count;
    for (int i = 0; i < _arrImagerURL.count; i++) {
        UIImageView *newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*_widthAD, 0, _widthAD, _heightAD)];
        newImageView.tag = i;
        newImageView.userInteractionEnabled = YES;
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:arrImagerURL[i]]];
        newImageView.image = [UIImage imageWithData:data];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [newImageView addGestureRecognizer:tap];
        [self.scrollViewAD addSubview:newImageView];
        [_arrImageView addObject:newImageView.image];
    }
    if (_rightImageView == nil) {
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake((_arrImagerURL.count)*_widthAD, 0, _widthAD, _heightAD)];
        _rightImageView.image = _arrImageView.firstObject;
        [self.scrollViewAD addSubview:_rightImageView];
    }
    if (_leftImageView == nil) {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-_widthAD, 0, _widthAD, _heightAD)];
        _leftImageView.image = _arrImageView.lastObject;
        [self.scrollViewAD addSubview:_leftImageView];
    }
    _scrollViewAD.contentSize = CGSizeMake(_widthAD*(_arrImagerURL.count +1), _heightAD);
    [self addTimeAD];
}

#pragma amrk - 私有方法
- (void)addTimeAD{
    if (_timeAD == nil) {
        _timeAD = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timeAD forMode:NSRunLoopCommonModes];
    }
}

- (void)removeTimeAD{
    [_timeAD invalidate];
    _timeAD = nil;
}

- (void)changeImage{
    ++_pageAD;
    CGFloat x = _pageAD * _widthAD;
    [self.scrollViewAD scrollRectToVisible:CGRectMake(x, 0, _widthAD, _heightAD) animated:YES];
}

- (void)pageVCTouch:(UIPageControl *)pageControl{
    CGFloat x = pageControl.currentPage * _widthAD;
    self.scrollViewAD.contentOffset = CGPointMake(x, 0);
}

- (void)tapGesture:(UITapGestureRecognizer *)tapGesture{
    NSLog(@"点击第个%d广告",tapGesture.view.tag);
    [self.delegate seleADPage:tapGesture.view.tag];
}

@end
