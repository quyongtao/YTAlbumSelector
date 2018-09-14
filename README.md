# YTAlbumSelector
@interface ViewController ()<YTAssetPickerNavViewControllerDelegate>
@end

@implementation ViewController
- (void)test{
	UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"YTAsset" bundle:nil];

    YTAssetGroupViewController *groupVC = [storyBoard instantiateViewControllerWithIdentifier:@"YTAssetGroupViewControllerID"];

    YTAssetPickerNavViewController *pickNav = [[YTAssetPickerNavViewController alloc]initWithRootViewController:groupVC];

    groupVC.assetsFilter = [ALAssetsFilter allPhotos];// 筛选相册要显示的图片类型 默认所有的图片和视频

    pickNav.assetsFilter = [ALAssetsFilter allPhotos];

    pickNav.maximumNumberOfSelection = 9;// 最大允许选择的图片数

    pickNav.pickerNavDelegate = self;//代理方法

    pickNav.globalSelectedArray = [self.currentSelectedAssetsArray mutableCopy];// 当前已经选择过的图片asset数组，方便进入相册后匹配已经选择过的图片

    [self presentViewController:pickNav animated:YES completion:nil];
}
#pragma 图片选择器的代理方法
/**
 * 只需实现这一个代理方法即可完成相册图片的选择
 *
*/
- (void)didFinishPickerAssets:(NSMutableArray *)assets{
    
    // 1.处理实际业务逻辑
    //*****


    // 2.assets包含了从相册选择的所有的图片对象
    for (int i=0; i< assets.count; i++) {
        
        //保存图片地址，下次回传
        ALAsset *asset = assets[i];
        // 高清图
//        UIImage *rolationImage=[UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage scale:asset.defaultRepresentation.scale orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
//        // 缩略图
//        UIImage *thumbImage=[UIImage imageWithCGImage:asset.thumbnail];
        
        // 此处可以实现自己的业务逻辑
        
    }
    // 3.根据业务需求处理TODO
    
    
}
@end
