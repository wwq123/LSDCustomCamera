//
//  LSDAssetTool.h
//  Photos框架研究
//
//  Created by SelenaWong on 17/2/13.
//  Copyright © 2017年 SelenaWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef void(^fetchAssetCollectionFinishedBlock)(PHAssetCollection *collection, NSString *error);
typedef void(^createAssetCollectionFinishedBlock)(PHAssetCollection *collection, NSString *error);
@interface LSDAssetTool : NSObject
@property (nonatomic, copy) fetchAssetCollectionFinishedBlock fetchAssectCollectionFinishedBlock;
@property (nonatomic, copy) createAssetCollectionFinishedBlock createAssetCollectionFinishedBlock;


/**
 获取图库权限状态

 @return 权限状态
 */
+ (PHAuthorizationStatus)getPhotoLibraryAuthorizationStatus;


/**
 检查图库权限

 @param complete 权限状态回调
 */
+ (void)checkAutorizationStatusComplete:(void(^)(PHAuthorizationStatus))complete;

/**
 根据给定的title查找对应的自定义相册是否存在

 @param title    相册名字
 @param complete 查找完成的回调
 */
+ (void)fetchAssetCollectionWithTitle:(NSString *)title complete:(fetchAssetCollectionFinishedBlock)complete;


/**
 获取相机胶卷

 @return 相机胶卷
 */
+ (PHAssetCollection *)getCameraRoll;


/**
 获得刚刚存在相机胶卷的相片

 @param image 要存的图片

 @return 刚刚存在相机胶卷的相片
 */
+ (PHFetchResult<PHAsset *> *)getPictureFromCamerRoll:(UIImage *)image;


/**
 保存相片到相机胶卷

 @param image 保存的相片
 */
+ (void)saveImageToAlbum:(UIImage *)image complete:(void(^)(UIImage*,NSString *))complete;


/**
 创建一个对应名字的自定义相册

 @param title    名字
 @param complete 创建完成的回调
 */
+ (void)createAssetCollectionWithTitle:(NSString *)title complete:(createAssetCollectionFinishedBlock)complete;
@end
