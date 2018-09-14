//
//  YTAssetCollectionCell.m
//  YTAssetPickerController
//
//  Created by quyongtao on 15/5/7.
//  Copyright (c) 2015年 yongtao. All rights reserved.
//

#import "YTAssetCollectionCell.h"

@implementation YTAssetCollectionCell

- (void)checkCell:(ALAsset *)asset externalArray:(NSArray *)externalArray
{
    _asset = asset;
    self.thumbImageView.image = [UIImage imageWithCGImage:asset.thumbnail];
    self.checkButton.selected = NO;
    self.tapView.backgroundColor = [UIColor clearColor];
    for (ALAsset *a in externalArray) {
        if ([asset.defaultRepresentation.url.absoluteString isEqualToString:a.defaultRepresentation.url.absoluteString]) {
            self.checkButton.selected = YES;
            self.tapView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
            break;
        }else{
            self.checkButton.selected = NO;
            self.tapView.backgroundColor = [UIColor clearColor];
        }
    }
}

- (IBAction)checkButtonAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    if ([self.delegate respondsToSelector:@selector(didSelectAsset:button:cell:)]) {
        [self.delegate didSelectAsset:_asset button:button cell:self];
    }
    
}
@end
