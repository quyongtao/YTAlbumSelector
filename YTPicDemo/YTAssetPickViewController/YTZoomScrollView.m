//
//  YTZoomScrollView.m
//  京彩生活
//
//  Created by quyongtao on 15/11/27.
//  Copyright © 2015年 zhaoyabin. All rights reserved.
//

#import "YTZoomScrollView.h"

@interface YTZoomScrollView() <UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *imageView;

@end


@implementation YTZoomScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUIWithFrame:frame];
    }
    return self;
}
- (void)buildUIWithFrame:(CGRect)frame
{
    self.backgroundColor = [UIColor clearColor];

    // 1.设置自己的参数
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.minimumZoomScale = 1.f;// 最小缩放比例
    self.maximumZoomScale = 2.f;// 最大缩放比例
    self.zoomScale = 1.f;// 当前比例
    
    // scrollView 增加点击手势
    // 双击
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    // 单击
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];// 优先响应双击
    
    // 2.设置子视图
    _imageView = [[UIImageView alloc] initWithFrame:frame];
    _imageView.userInteractionEnabled = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageView];
}
- (void)setImageViewWithImage:(UIImage *)image
{
    _imageView.image = image;
    
    _imageView.center = CGPointMake(self.bounds.size.width / 2.f, self.bounds.size.height / 2.f);
    _imageView.bounds = CGRectMake(0, 0, self.bounds.size.width, image.size.height * self.bounds.size.width / image.size.width);
    
}
#pragma mark 手势 -
#pragma mark scrollView 单击手势
- (void)singleTap:(UITapGestureRecognizer *)gesture
{
    // 显示隐藏导航栏和底部栏
    if (self.tapScrollViewCallBack) {
        self.tapScrollViewCallBack();
    }
}
#pragma mark scrollView 双击手势
- (void)doubleTap:(UITapGestureRecognizer *)gesture
{
    CGPoint tapPoint = [gesture locationInView:self];
    if (self.zoomScale == self.maximumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }else{
        [self zoomToRect:CGRectMake(tapPoint.x, tapPoint.y, 1, 1) animated:YES];
    }
}
#pragma mark - scrollView 代理方法
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat centerX = scrollView.contentSize.width > scrollView.bounds.size.width ? scrollView.contentSize.width / 2.f : self.bounds.size.width / 2.f;
    CGFloat centerY = scrollView.contentSize.height > scrollView.bounds.size.height ? scrollView.contentSize.height / 2.f : self.bounds.size.height / 2.f;
    _imageView.center = CGPointMake(centerX, centerY);
    
}

@end
