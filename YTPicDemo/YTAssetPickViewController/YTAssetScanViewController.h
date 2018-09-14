//
//  YTAssetScanViewController.h
//  YTAssetPickerController
//
//  Created by quyongtao on 15/5/7.
//  Copyright (c) 2015年 yongtao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum AssetsType
{
    AssetsTypeSelected = 0,//只显示选中的图片浏览
    AssetsTypeAll,//全部的图片浏览
    AssetsTypeExternal//来自外部的单纯浏览
}AssetsType;

typedef void (^selectedBlock)(NSIndexPath *);

@interface YTAssetScanViewController : UIViewController

@property (nonatomic,strong) NSMutableArray *assets;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
- (IBAction)finishButtonAction:(id)sender;

@property (nonatomic,assign) NSInteger selectedIndex;

@property (nonatomic,copy) selectedBlock selectedCallBack;

@property (nonatomic,assign) AssetsType assetsType;

@end
