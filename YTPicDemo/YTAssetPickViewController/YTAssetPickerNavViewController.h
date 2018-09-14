//
//  YTAssetPickerNavViewController.h
//  YTAssetPickerController
//
//  Created by quyongtao on 15/5/7.
//  Copyright (c) 2015年 yongtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "YTAssetLibrary.h"

@protocol YTAssetPickerNavViewControllerDelegate;
@class YTAssetGroupViewController;

@interface YTAssetPickerNavViewController : UINavigationController

@property (nonatomic,strong) NSMutableArray *globalSelectedArray;//存放最终的asset对象

@property (nonatomic,weak) id<YTAssetPickerNavViewControllerDelegate>pickerNavDelegate;

@property (nonatomic, assign) NSInteger maximumNumberOfSelection;//允许选择的最大的图片数
@property (nonatomic, assign) NSInteger minimumNumberOfSelection;//允许选择的最小的图片数-可以不做限制

@property (nonatomic, strong) ALAssetsFilter *assetsFilter;//只匹配所有照片

@property (nonatomic,strong) NSMutableArray *globalTempSelectedArray;//存放临时选择的asset对象-暂时不用

/**
 *  完成选择图片操作
 */
- (void)finishSelectedAssets;

@end


@protocol YTAssetPickerNavViewControllerDelegate <NSObject>

/**
 *  照片最终选择完毕 点击完成按钮后触发的代理方法
 *
 *  @param assets 存放最终的asset对象的数组
 */
- (void)didFinishPickerAssets:(NSMutableArray *)assets;

@end
