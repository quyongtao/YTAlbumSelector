//
//  YTAssetViewController.h
//  YTAssetPickerController
//
//  Created by quyongtao on 15/5/7.
//  Copyright (c) 2015年 yongtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface YTAssetViewController : UIViewController

@property (nonatomic,strong) ALAssetsGroup* assetsGroup;//存放来自外界的group
@property (nonatomic,strong) NSMutableArray *selectedAssetsArray;//被选中的asset对象

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *previewButton;

@property (weak, nonatomic) IBOutlet UIButton *finishButton;
- (IBAction)previewButtonAction:(id)sender;
- (IBAction)finishButton:(id)sender;

@end
