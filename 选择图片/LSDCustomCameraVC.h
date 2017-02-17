//
//  LSDCustomCameraVC.h
//  选择图片-单张
//
//  Created by SelenaWong on 17/2/16.
//  Copyright © 2017年 SelenaWong. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 拍照完成的回调
 */
typedef void(^captureFinishedBlock)(UIImage *image,NSError *error);
@interface LSDCustomCameraVC : UIViewController
@property (nonatomic, copy) captureFinishedBlock captureFinishedBlock;
@end
