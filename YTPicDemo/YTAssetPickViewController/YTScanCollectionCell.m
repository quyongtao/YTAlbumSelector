//
//  YTScanCollectionCell.m
//  YTAssetPickerController
//
//  Created by quyongtao on 15/5/7.
//  Copyright (c) 2015年 yongtao. All rights reserved.
//

#import "YTScanCollectionCell.h"
#import "YTZoomScrollView.h"
#import "YTConstant.h"

#define kScale 2.0f

@interface YTScanCollectionCell()

@property (nonatomic,assign) CGFloat lastScale;
@property (nonatomic,strong) YTZoomScrollView *zoomScrollView;// 可以缩放的放大缩小的zoomScrollView

@end

@implementation YTScanCollectionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // 2.2.4新增 可以放大缩小的scrollView
    _zoomScrollView = [[YTZoomScrollView alloc] initWithFrame:CGRectMake(0, 0, kCurrentScreenW, kCurrentScreenH)];
    __weak typeof (self) weakSelf = self;
    _zoomScrollView.tapScrollViewCallBack = ^(){// 回调方法
        if ([weakSelf.delegate respondsToSelector:@selector(hideNav)]) {
            [weakSelf.delegate hideNav];
        }
    };
    [self.contentView addSubview:_zoomScrollView];
    
}

- (void)checkCell:(ALAsset *)asset
{
    
    [_zoomScrollView setImageViewWithImage:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage scale:asset.defaultRepresentation.scale orientation:(UIImageOrientation)asset.defaultRepresentation.orientation]];
}

@end
