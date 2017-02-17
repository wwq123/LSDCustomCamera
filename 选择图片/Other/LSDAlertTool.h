//
//  LSDAlertTool.h
//  选择图片-单张
//
//  Created by SelenaWong on 17/2/15.
//  Copyright © 2017年 SelenaWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol LSDAlertToolDelegate <NSObject>

@optional

/**
 方法回调

 @param action UIAlertAction对象
 @param index  对应的action
 @param tag    区分哪个提示框
 */
- (void)action:(UIAlertAction *)action handleForActionIndex:(NSInteger)index tag:(NSInteger)tag;
@end

@interface LSDAlertTool : NSObject

/**
 快速构建方法

 @param title        提示框标题
 @param message      提示框描述信息
 @param actionTitles 提示框按钮标题数组
 @param actionsStyle 提示框按钮风格，0:表示默认 1:取消 2:警示
 @param tag          用来区分是哪个提示框，当有多个提示框的时候
 @param delegate     代理，用来执行按钮对应的操作
 @param vc           弹出提示框的控制器
 */
+ (void)showAlertSheetWithTitle:(NSString *)title
                        message:(NSString *)message
                   actionTitles:(NSArray<NSString *> *)actionTitles
                   actionsStyle:(NSArray<NSNumber *> *)actionsStyle
                            tag:(NSInteger)tag
                       delegate:(id<LSDAlertToolDelegate>)delegate
                       showToVC:(UIViewController *)vc;
@end
