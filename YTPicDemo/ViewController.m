//
//  ViewController.m
//  YTPicDemo
//
//  Created by quyongtao on 2017/4/13.
//  Copyright © 2017年 quyongtao. All rights reserved.
//

#import "ViewController.h"
#import "YTAssetPickerNavViewController.h"
#import "YTAssetGroupViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "YTConstant.h"
#import "YTAssetScanViewController.h"

@interface ViewController ()<YTAssetPickerNavViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) NSMutableArray *imageViewArray;

@property (nonatomic,strong) NSMutableArray *currentSelectedAssetsArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kCurrentScreenW / 2 -  100 / 2, kCurrentScreenH - 100, 100, 100);
    [button addTarget:self action:@selector(choicePicAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"选图" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
}
- (void)choicePicAction:(UIButton *)button
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *canelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:canelAction];
    
    UIAlertAction *choicePicAction = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self gotoChoicePic];
    }];
    [alertVC addAction:choicePicAction];
    
    UIAlertAction *cameraPicAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self gotoCamera];
    }];
    [alertVC addAction:cameraPicAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)gotoCamera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"模拟器不支持摄像头" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
        
    }
    
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    __weak typeof (self) weakSelf = self;
    [[YTAssetLibrary sharedInstance]writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        [[YTAssetLibrary sharedInstance]assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            
            [weakSelf.currentSelectedAssetsArray addObject:asset];
            
            [weakSelf buildUIImageView:weakSelf.currentSelectedAssetsArray];
            
        } failureBlock:^(NSError *error) {
        }];
    }];
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
    
}
- (void)gotoChoicePic
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"YTAsset" bundle:nil];
    YTAssetGroupViewController *groupVC = [storyBoard instantiateViewControllerWithIdentifier:@"YTAssetGroupViewControllerID"];
    YTAssetPickerNavViewController *pickNav = [[YTAssetPickerNavViewController alloc]initWithRootViewController:groupVC];
    groupVC.assetsFilter = [ALAssetsFilter allPhotos];
    pickNav.assetsFilter = [ALAssetsFilter allPhotos];
    pickNav.maximumNumberOfSelection = 9;
    pickNav.pickerNavDelegate = self;
    pickNav.globalSelectedArray = [self.currentSelectedAssetsArray mutableCopy];
    [self presentViewController:pickNav animated:YES completion:nil];

}
#pragma mark - YTAssetPickerNavViewController Delegate
- (void)didFinishPickerAssets:(NSMutableArray *)assets
{
    
    [self.currentSelectedAssetsArray removeAllObjects];
    for (int i=0; i< assets.count; i++) {
        
        //保存图片地址，下次回传
        ALAsset *asset = assets[i];
        // 高清图
//        UIImage *rolationImage=[UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage scale:asset.defaultRepresentation.scale orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
//        // 缩略图
//        UIImage *thumbImage=[UIImage imageWithCGImage:asset.thumbnail];
        
        [self.currentSelectedAssetsArray addObject:asset];
        
    }
    
    
    [self buildUIImageView:self.currentSelectedAssetsArray];
}
- (void)buildUIImageView:(NSMutableArray *)assetImageArray
{
    for (id object in self.imageViewArray) {
        [object removeFromSuperview];
    }
    [self.imageViewArray removeAllObjects];
    
    for (NSInteger i = 0; i < assetImageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.borderColor = [UIColor redColor].CGColor;
        imageView.layer.borderWidth = 1;
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        ALAsset *asset = assetImageArray[i];
        // 缩略图
        UIImage *thumbImage=[UIImage imageWithCGImage:asset.thumbnail];
        imageView.image = thumbImage;
        
        imageView.frame = CGRectMake(i % 4 * 55 + 10, i / 4 * 55 + 100, 50, 50);
        [self.view addSubview:imageView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(previewImageView:)];
        [imageView addGestureRecognizer:tapGesture];
        
        [self.imageViewArray addObject:imageView];
    }
}
- (void)previewImageView:(UIGestureRecognizer *)gesture
{
    UIImageView *imageView = (UIImageView *)gesture.view;
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"YTAsset" bundle:nil];
    YTAssetScanViewController *scanVC = [storyBoard instantiateViewControllerWithIdentifier:@"YTAssetScanViewControllerID"];
    YTAssetPickerNavViewController *pickNav = [[YTAssetPickerNavViewController alloc]initWithRootViewController:scanVC];
    scanVC.assets = [self.currentSelectedAssetsArray mutableCopy];
    scanVC.selectedIndex = imageView.tag;
    scanVC.assetsType = AssetsTypeExternal;
    
    [self presentViewController:pickNav animated:YES completion:nil];
}
- (NSMutableArray *)imageViewArray
{
    if (!_imageViewArray) {
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}
- (NSMutableArray *)currentSelectedAssetsArray
{
    if (!_currentSelectedAssetsArray) {
        _currentSelectedAssetsArray = [NSMutableArray array];
    }
    return _currentSelectedAssetsArray;
}

@end
