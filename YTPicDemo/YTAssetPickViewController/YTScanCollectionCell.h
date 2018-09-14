//
//  YTScanCollectionCell.h
//  YTAssetPickerController
//
//  Created by quyongtao on 15/5/7.
//  Copyright (c) 2015年 yongtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol YTScanCollectionCellDelegate;

@interface YTScanCollectionCell : UICollectionViewCell

- (void)checkCell:(ALAsset *)asset;

@property (nonatomic,weak) id <YTScanCollectionCellDelegate>delegate;

@end

@protocol YTScanCollectionCellDelegate <NSObject>

- (void)hideNav;

@end
