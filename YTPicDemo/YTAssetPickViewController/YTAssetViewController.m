//
//  YTAssetViewController.m
//  YTAssetPickerController
//
//  Created by quyongtao on 15/5/7.
//  Copyright (c) 2015年 yongtao. All rights reserved.
//

#import "YTAssetViewController.h"
#import "YTAssetCollectionCell.h"
#import "YTAssetScanViewController.h"
#import "YTAssetPickerNavViewController.h"

#define kBottomH 44.f
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kCollectionCellID @"collectionCellID"

@interface YTAssetViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,YTAssetCollectionCellDelegate>

@property (nonatomic,strong) NSMutableArray *assets;//存放所有的asset对象数组

@end

@implementation YTAssetViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    YTAssetPickerNavViewController *pickNav = (YTAssetPickerNavViewController *)self.navigationController;
    self.previewButton.enabled = pickNav.globalSelectedArray.count > 0;
    self.finishButton.enabled = pickNav.globalSelectedArray.count > 0;
    if (pickNav.globalSelectedArray.count) {
        NSString *title = [NSString stringWithFormat:@"(%lu)完成",(unsigned long)pickNav.globalSelectedArray.count];
        [self.finishButton setTitle:title forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildAssets];
}
- (void)buildAssets
{
    
    self.title = [NSString stringWithFormat:@"%@",NSLocalizedString([self.assetsGroup valueForProperty:ALAssetsGroupPropertyName], nil)];
    
    __weak typeof(self) weakSelf = self;
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        
        if (asset)
        {
            
            NSString *type = [asset valueForProperty:ALAssetPropertyType];
            
            if ([type isEqual:ALAssetTypePhoto]) {
                [weakSelf.assets addObject:asset];
            }
        }
        
        else if (weakSelf.assets.count > 0)
        {
            [weakSelf.collectionView reloadData];
            [self.collectionView layoutIfNeeded];
            [self.collectionView setNeedsUpdateConstraints];
            NSLog(@"%f--%f",self.collectionView.contentSize.height, self.collectionView.bounds.size.height);
            CGFloat offsetY = self.collectionView.contentSize.height - self.collectionView.bounds.size.height > 0 ? self.collectionView.contentSize.height - self.collectionView.bounds.size.height + 64 : 0;
            CGPoint bottomOffset = CGPointMake(0, offsetY);
            [self.collectionView setContentOffset:bottomOffset animated:NO];
        }
    };
    
    [self.assetsGroup enumerateAssetsUsingBlock:resultsBlock];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView DataSource & Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YTAssetCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellID forIndexPath:indexPath];
    ALAsset *asset = self.assets[indexPath.row];
    YTAssetPickerNavViewController *pickNav = (YTAssetPickerNavViewController *)self.navigationController;
    [cell checkCell:asset externalArray:pickNav.globalSelectedArray];
    cell.delegate = self;
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.bounds.size.width - 3 * 4) / 4.f, (collectionView.bounds.size.width - 3 * 4) / 4.f);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 4.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4.f;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionFooter) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        UILabel *label = [[UILabel alloc]initWithFrame:reusableView.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18.f];
        label.textColor = [UIColor blackColor];
        label.text = [NSString stringWithFormat:@"%ld张照片",(long)self.assetsGroup.numberOfAssets];
        [reusableView addSubview:label];
    }
    return reusableView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(kScreenW, 44.f);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"YTAsset" bundle:nil];
    YTAssetScanViewController *scanVC = [storyBoard instantiateViewControllerWithIdentifier:@"YTAssetScanViewControllerID"];
    
    scanVC.assets = self.assets;
    scanVC.selectedIndex = indexPath.row;
    scanVC.assetsType = AssetsTypeAll;
    
    __weak typeof(self) weakSelf = self;
    scanVC.selectedCallBack = ^(NSIndexPath *indexPath){
        if (indexPath) {
            
            [weakSelf.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        }
    };
    
    [self.navigationController pushViewController:scanVC animated:YES];
}
#pragma mark cell Delegate
- (void)didSelectAsset:(ALAsset *)asset button:(UIButton *)button cell:(YTAssetCollectionCell *)cell
{
    YTAssetPickerNavViewController *pickNav = (YTAssetPickerNavViewController *)self.navigationController;
    if (button.selected) {
        [pickNav.globalSelectedArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ALAsset *globalAsset = (ALAsset *)obj;
            if ([globalAsset.defaultRepresentation.url.absoluteString isEqualToString:asset.defaultRepresentation.url.absoluteString]) {
                [pickNav.globalSelectedArray removeObject:globalAsset];
            }
        }];
        [pickNav.globalTempSelectedArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ALAsset *globalAsset = (ALAsset *)obj;
            if ([globalAsset.defaultRepresentation.url.absoluteString isEqualToString:asset.defaultRepresentation.url.absoluteString]) {
                [pickNav.globalTempSelectedArray removeObject:globalAsset];
            }
        }];
        
    }else{
        if (pickNav.globalSelectedArray.count > pickNav.maximumNumberOfSelection - 1) {
            NSString *message = [NSString stringWithFormat:@"最多选择%ld张图片",(long)pickNav.maximumNumberOfSelection];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        [pickNav.globalSelectedArray addObject:asset];
        [pickNav.globalTempSelectedArray addObject:asset];
    }
    button.selected = !button.selected;
    cell.tapView.backgroundColor = button.selected ? [UIColor colorWithWhite:1.0f alpha:0.3f] : [UIColor clearColor];
    
    self.previewButton.enabled = pickNav.globalSelectedArray.count > 0;
    self.finishButton.enabled = pickNav.globalSelectedArray.count > 0;
    if (pickNav.globalSelectedArray.count) {
        NSString *title = [NSString stringWithFormat:@"(%lu)完成",(unsigned long)pickNav.globalSelectedArray.count];
        [self.finishButton setTitle:title forState:UIControlStateNormal];
    }else{
        [self.finishButton setTitle:@"完成" forState:UIControlStateDisabled];
    }
}
- (NSMutableArray *)assets
{
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}
- (IBAction)previewButtonAction:(id)sender {
    
    YTAssetPickerNavViewController *pickNav = (YTAssetPickerNavViewController *)self.navigationController;
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"YTAsset" bundle:nil];
    YTAssetScanViewController *scanVC = [storyBoard instantiateViewControllerWithIdentifier:@"YTAssetScanViewControllerID"];
    
    scanVC.assets = pickNav.globalSelectedArray;
    scanVC.selectedIndex = 0;
    scanVC.assetsType = AssetsTypeSelected;
    
    __weak typeof(self) weakSelf = self;
    scanVC.selectedCallBack = ^(NSIndexPath *indexPath){
        if (indexPath) {
            
            [weakSelf.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        }else{
            [weakSelf.collectionView reloadData];
        }
    };
    
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (IBAction)finishButton:(id)sender {
    YTAssetPickerNavViewController *pickNav = (YTAssetPickerNavViewController *)self.navigationController;
    [pickNav finishSelectedAssets];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
