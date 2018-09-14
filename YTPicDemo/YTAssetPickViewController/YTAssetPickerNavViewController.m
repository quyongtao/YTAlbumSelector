//
//  YTAssetPickerNavViewController.m
//  YTAssetPickerController
//
//  Created by quyongtao on 15/5/7.
//  Copyright (c) 2015年 yongtao. All rights reserved.
//

#import "YTAssetPickerNavViewController.h"
#import "YTAssetGroupViewController.h"

@interface YTAssetPickerNavViewController ()

@end

@implementation YTAssetPickerNavViewController

- (NSMutableArray *)globalSelectedArray
{
    if (!_globalSelectedArray) {
        _globalSelectedArray = [NSMutableArray array];
    }
    return _globalSelectedArray;
}
- (NSMutableArray *)globalTempSelectedArray
{
    if (!_globalTempSelectedArray) {
        _globalTempSelectedArray = [NSMutableArray array];
    }
    return _globalTempSelectedArray;
}
- (void)finishSelectedAssets
{
    if ([self.pickerNavDelegate respondsToSelector:@selector(didFinishPickerAssets:)]) {
        [self.pickerNavDelegate didFinishPickerAssets:self.globalSelectedArray];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
}

@end
