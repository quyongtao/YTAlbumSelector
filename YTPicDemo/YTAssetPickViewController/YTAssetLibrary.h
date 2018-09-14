//
//  YTAssetLibrary.h
//  YTAssetPickerController
//
//  Created by quyongtao on 15/5/7.
//  Copyright (c) 2015年 yongtao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface YTAssetLibrary : ALAssetsLibrary

+(YTAssetLibrary *)sharedInstance;


@end
