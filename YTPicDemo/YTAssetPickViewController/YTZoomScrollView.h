//
//  YTZoomScrollView.h
//  京彩生活
//
//  Created by quyongtao on 15/11/27.
//  Copyright © 2015年 zhaoyabin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTZoomScrollView : UIScrollView

/**
 *  初始化方法
 *
 *  @param frame 对象frame
 *
 *  @return 返回对象本身
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 *  目的是为了显示和隐藏导航啦已经状态栏
 */
@property (nonatomic,copy) void(^tapScrollViewCallBack)();

/**
 *  数据源赋值方法
 *
 *  @param image 外部传入的数据
 */
- (void)setImageViewWithImage:(UIImage *)image;

@end
