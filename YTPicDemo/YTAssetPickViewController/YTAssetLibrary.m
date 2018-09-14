//
//  YTAssetLibrary.m
//  YTAssetPickerController
//
//  Created by quyongtao on 15/5/7.
//  Copyright (c) 2015年 yongtao. All rights reserved.
//

#import "YTAssetLibrary.h"

@implementation YTAssetLibrary

static YTAssetLibrary *library = nil;
+ (YTAssetLibrary *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        library = [[YTAssetLibrary alloc]init];
    });
    return library;
}

@end
