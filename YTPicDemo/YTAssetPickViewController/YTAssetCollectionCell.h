//
//  YTAssetCollectionCell.h
//  YTAssetPickerController
//
//  Created by quyongtao on 15/5/7.
//  Copyright (c) 2015年 yongtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol YTAssetCollectionCellDelegate;

@interface YTAssetCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *tapView;

@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;

@property (weak, nonatomic) IBOutlet UIButton *checkButton;
- (IBAction)checkButtonAction:(id)sender;

- (void)checkCell:(ALAsset *)asset externalArray:(NSArray *)externalArray;

@property (nonatomic,strong) ALAsset *asset;

@property (nonatomic,weak) id <YTAssetCollectionCellDelegate> delegate;

@end

@protocol YTAssetCollectionCellDelegate <NSObject>

- (void)didSelectAsset:(ALAsset *)asset button:(UIButton *)button cell:(YTAssetCollectionCell *)cell;

@end
