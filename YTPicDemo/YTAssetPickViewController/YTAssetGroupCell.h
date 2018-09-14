//
//  YTAssetGroupCell.h
//  YTAssetPickerController
//
//  Created by quyongtao on 15/5/7.
//  Copyright (c) 2015年 yongtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

//缩略图的尺寸
#define kThumbnailLength    75.f
#define kThumbnailSize      CGSizeMake(kThumbnailLength, kThumbnailLength)

@interface YTAssetGroupCell : UITableViewCell

@property (nonatomic,strong) ALAssetsGroup *assetsGroup;

@end
