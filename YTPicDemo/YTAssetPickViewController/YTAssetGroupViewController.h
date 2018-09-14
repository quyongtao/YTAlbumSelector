//
//  YTAssetGroupViewController.h
//  YTAssetPickerController
//
//  Created by quyongtao on 15/5/7.
//  Copyright (c) 2015年 yongtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface YTAssetGroupViewController : UIViewController

@property (nonatomic,strong) NSMutableArray *externalArray;//接收外部传来的array-存放asset对象

@property (nonatomic, strong) ALAssetsFilter *assetsFilter;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
