//
//  YTAssetScanViewController.m
//  YTAssetPickerController
//
//  Created by quyongtao on 15/5/7.
//  Copyright (c) 2015年 yongtao. All rights reserved.
//

#import "YTAssetScanViewController.h"
#import "YTScanCollectionCell.h"
#import "YTAssetPickerNavViewController.h"

#define kScanCollectionViewCellID @"scanCollectionViewCellID"
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface YTAssetScanViewController () <YTScanCollectionCellDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIButton *rightButton;

@property (nonatomic,assign) int currentPage;

@end


@implementation YTAssetScanViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication]setStatusBarHidden:self.navigationController.navigationBarHidden withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildNav];
    
    
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    [self.collectionView setNeedsUpdateConstraints];
    
    CGPoint bottomOffset = CGPointMake(self.selectedIndex * self.collectionView.bounds.size.width, 0);
    [self.collectionView setContentOffset:bottomOffset animated:NO];
    
    self.rightButton.selected = [self isSelectedButton:self.selectedIndex];
    
    YTAssetPickerNavViewController *pickNav = (YTAssetPickerNavViewController *)self.navigationController;
    self.finishButton.enabled = pickNav.globalSelectedArray.count > 0;
    if (pickNav.globalSelectedArray.count) {
        NSString *title = [NSString stringWithFormat:@"(%lu)完成",(unsigned long)pickNav.globalSelectedArray.count];
        [self.finishButton setTitle:title forState:UIControlStateNormal];
    }else{
        [self.finishButton setTitle:@"完成" forState:UIControlStateDisabled];
    }
    
    if (self.assetsType == AssetsTypeExternal) {
        self.bottomView.hidden = YES;
        self.rightButton.hidden = YES;
    }else{
        self.bottomView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.85f];
    }
}
- (void)buildNav
{
    
    self.title = [NSString stringWithFormat:@"%ld/%lu",self.selectedIndex + 1,(unsigned long)self.assets.count];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *normalImage = [UIImage imageNamed:@"btn_check_normal"];
    button.frame = CGRectMake(0, 0, normalImage.size.width, normalImage.size.height);
    [button setImage:[UIImage imageNamed:@"btn_check_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"btn_check_selected"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(selectedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    _rightButton = button;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    if (self.assetsType == AssetsTypeExternal) {
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, 44, 44);
        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
        leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [leftButton addTarget:self action:@selector(cancelVC:) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    }
    
}
- (void)cancelVC:(UIButton *)button
{
    if (self.assetsType == AssetsTypeExternal) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)selectedButtonAction:(UIButton *)button
{
    YTAssetPickerNavViewController *pickNav = (YTAssetPickerNavViewController *)self.navigationController;
    ALAsset *asset = [self.assets objectAtIndex:_currentPage];
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
    if (self.selectedCallBack) {
        if (self.assetsType == AssetsTypeAll) {
            self.selectedCallBack([NSIndexPath indexPathForItem:_currentPage inSection:0]);
        }else{
            self.selectedCallBack(nil);
        }
    }
    self.finishButton.enabled = pickNav.globalSelectedArray.count > 0;
    if (pickNav.globalSelectedArray.count) {
        NSString *title = [NSString stringWithFormat:@"(%lu)完成",(unsigned long)pickNav.globalSelectedArray.count];
        [self.finishButton setTitle:title forState:UIControlStateNormal];
    }else{
        [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
    }
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
    YTScanCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kScanCollectionViewCellID forIndexPath:indexPath];
    cell.delegate = self;
    ALAsset *asset = self.assets[indexPath.row];
    
    [cell checkCell:asset];
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return .0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return .0f;
}
#pragma mark scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + kScreenW / 2) /  kScreenW;

    self.title = [NSString stringWithFormat:@"%d/%lu",page+1,self.assets.count];
    
    _currentPage = page;
    
    self.rightButton.selected = [self isSelectedButton:page];
    
    
    YTAssetPickerNavViewController *pickNav = (YTAssetPickerNavViewController *)self.navigationController;
    self.finishButton.enabled = pickNav.globalSelectedArray.count > 0;
    if (pickNav.globalSelectedArray.count) {
        NSString *title = [NSString stringWithFormat:@"(%lu)完成",(unsigned long)pickNav.globalSelectedArray.count];
        [self.finishButton setTitle:title forState:UIControlStateNormal];
    }else{
        [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
    }
    
    NSLog(@"----%d",page);
}
- (BOOL)isSelectedButton:(NSInteger)index
{
    YTAssetPickerNavViewController *pickNav = (YTAssetPickerNavViewController *)self.navigationController;
    for (ALAsset *globalAsset in pickNav.globalSelectedArray) {
        ALAsset *currentAsset = [self.assets objectAtIndex:index];
        if ([currentAsset.defaultRepresentation.url.absoluteString isEqualToString:globalAsset.defaultRepresentation.url.absoluteString]) {
            return YES;
        }
    }
    return NO;
}
#pragma mark cell Delegate
- (void)hideNav
{
    self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
    [[UIApplication sharedApplication]setStatusBarHidden:self.navigationController.navigationBarHidden withAnimation:UIStatusBarAnimationNone];
    self.bottomView.hidden = self.assetsType == AssetsTypeExternal ? YES :!self.bottomView.hidden;
}
- (NSMutableArray *)assets
{
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}

- (IBAction)finishButtonAction:(id)sender {
    YTAssetPickerNavViewController *pickNav = (YTAssetPickerNavViewController *)self.navigationController;
    [pickNav finishSelectedAssets];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
