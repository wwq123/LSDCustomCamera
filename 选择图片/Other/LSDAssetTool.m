//
//  LSDAssetTool.m
//  Photos框架研究
//
//  Created by SelenaWong on 17/2/13.
//  Copyright © 2017年 SelenaWong. All rights reserved.
//

#import "LSDAssetTool.h"

@implementation LSDAssetTool

+ (PHAuthorizationStatus)getPhotoLibraryAuthorizationStatus{
    return [PHPhotoLibrary authorizationStatus];
}

+ (void)checkAutorizationStatusComplete:(void (^)(PHAuthorizationStatus ))complete{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(status);
        });
    }];
}
+ (void)fetchAssetCollectionWithTitle:(NSString *)title complete:(fetchAssetCollectionFinishedBlock)complete{
    if (!title) {
        if (complete) {
            complete(nil,@"相册名字不能为空");
        }
        return;
    }
    __block PHAssetCollection *collection = nil;
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *assetCol in result) {
        if ([assetCol.localizedTitle isEqualToString:title]) {
            collection = assetCol;
            break;
        }
    }
    if (collection) {
        if (complete) {
            complete(collection,nil);
        }
    }else{
        if (complete) {
            complete(nil,@"寻找的相册不存在");
        }
    }
}

+ (PHAssetCollection *)getCameraRoll{
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    for (PHAssetCollection *assetCol in result) {
        NSLog(@"colName : %@",assetCol.localizedTitle);
    }
    return [result firstObject];
}

+ (PHFetchResult<PHAsset *> *)getPictureFromCamerRoll:(UIImage *)image{
    if (!image) {
        return nil;
    }
    
    NSError *error = nil;
    __block NSString *asset_Id = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        asset_Id = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    if (error) {
        return nil;
    }
   return [PHAsset fetchAssetsWithLocalIdentifiers:@[asset_Id] options:nil];
}

+ (void)saveImageToAlbum:(UIImage *)image complete:(void(^)(UIImage*,NSString *))complete{
    if (!image) {
        complete(nil,@"图片不存在");
        return;
    }
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } error:&error];
    if (error) {
        complete(nil,error.localizedDescription);
    }
}

+ (void)createAssetCollectionWithTitle:(NSString *)title complete:(createAssetCollectionFinishedBlock)complete{
    [self fetchAssetCollectionWithTitle:title complete:^(PHAssetCollection *collection, NSString *error) {
        if (collection) {
            if (complete) {
                complete(collection,nil);
            }
        }else{
            if (error) {
                if ([error isEqualToString:@"相册名字不能为空"]) {
                    if (complete) {
                        complete(nil,error);
                    }
                }else{
                    __block NSString *collection_Id = nil;
                    __block PHAssetCollection *collection = nil;
                    NSError *errors = nil;
                    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                        //创建相册必获取带创建相册的标示符
                        collection_Id = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
                    } error:&errors];
                    if (errors) {//表示相册创建失败
                        if (complete) {
                            complete(nil,errors.localizedDescription);
                            return;
                        }
                    }
                    collection = [[PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collection_Id] options:nil] firstObject];
                    if (complete) {
                        complete(collection,nil);
                    }
                }
            }
        }
    }];
}
@end
