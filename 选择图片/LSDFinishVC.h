//
//  LSDFinishVC.h
//  选择图片-单张
//
//  Created by SelenaWong on 17/2/16.
//  Copyright © 2017年 SelenaWong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^finishBlock)(UIImage *image);
@interface LSDFinishVC : UIViewController
@property (nonatomic, copy) finishBlock finishBlock;
- (instancetype)initWithImage:(UIImage *)image;
@end
