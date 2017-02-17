//
//  LSDAlertTool.m
//  选择图片-单张
//
//  Created by SelenaWong on 17/2/15.
//  Copyright © 2017年 SelenaWong. All rights reserved.
//

#import "LSDAlertTool.h"
#import <UIKit/UIKit.h>

@implementation LSDAlertTool
+ (void)showAlertSheetWithTitle:(NSString *)title message:(NSString *)message actionTitles:(NSArray<NSString *> *)actionTitles actionsStyle:(NSArray<NSNumber *> *)actionsStyle tag:(NSInteger)tag delegate:(id<LSDAlertToolDelegate>)delegate showToVC:(UIViewController *)vc{
    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i=0; i<actionTitles.count; i++) {
        NSString *actionTitle = actionTitles[i];
        NSInteger actionStyle = [actionsStyle[i] integerValue];
        UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:actionStyle handler:^(UIAlertAction * _Nonnull action) {
            if ([delegate respondsToSelector:@selector(action:handleForActionIndex:tag:)]) {
                [delegate action:action handleForActionIndex:i tag:tag];
            }
        }];
        [alertSheet addAction:action];
    }
//    [[UIApplication sharedApplication].windows.lastObject.rootViewController presentViewController:alertSheet animated:YES completion:nil];
    [vc presentViewController:alertSheet animated:YES completion:nil];
}
@end
