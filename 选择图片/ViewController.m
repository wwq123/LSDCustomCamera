//
//  ViewController.m
//  选择图片
//
//  Created by SelenaWong on 17/2/14.
//  Copyright © 2017年 SelenaWong. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LSDAlertTool.h"
#import "LSDCustomCameraVC.h"

@interface ViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,LSDAlertToolDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *selectPicBtn;
@end

@implementation ViewController

/*
 一.从相册中选择图片
 1.选择单张图片
 1>UIImagePickerController (自带界面)
 2>AssetsLibrary框架        (开发者自己自定义搭建界面)
 3>Photos框架               (开发者自己自定义搭建界面)
 
 2.选择多张图片
 1>AssetsLibrary框架        (开发者自己自定义搭建界面)
 2>Photos框架               (开发者自己自定义搭建界面)
 
 二.利用相机拍摄一张图片到App
 1>UIImagePickerController (自带界面)
 2>利用<AVFoundation/AVFoundation.h>框架中的AVCapture...类 (开发者自己自定义搭建界面)
 
 
 
 */
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)selectPicBtnClick:(UIButton *)sender {
    [LSDAlertTool showAlertSheetWithTitle:nil message:nil actionTitles:@[@"相册中选择",@"拍照",@"取消"] actionsStyle:@[@(0),@(0),@(1)] tag:100 delegate:self showToVC:self];
}


#pragma mark - LSDAlertToolDelegate
- (void)action:(UIAlertAction *)action handleForActionIndex:(NSInteger)index tag:(NSInteger)tag{
    switch (index) {
        case 0:
            [self selectPictureFromSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
            
        case 1:
//            [self selectPictureFromSourceType:UIImagePickerControllerSourceTypeCamera];
            [self showCustomCamera];
            break;
            
        default:
            break;
    }
}

#pragma mark - 弹出自定义相机
- (void)showCustomCamera{
    LSDCustomCameraVC *cameraVC = [[LSDCustomCameraVC alloc] init];
    __weak typeof(self) weakSelf = self;
    __weak typeof(cameraVC) weakCameraVC = cameraVC;
    cameraVC.captureFinishedBlock = ^(UIImage *image,NSError *error){
        if (!error) {
            [weakCameraVC dismissViewControllerAnimated:YES completion:nil];
            weakSelf.imageView.image = image;
        }else{
            NSLog(@"error : %@",error);
        }
    };
    [self presentViewController:cameraVC animated:YES completion:nil];
}

#pragma mark - 弹出系统的相机和图库
- (void)selectPictureFromSourceType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = sourceType;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"info : %@",info);
    if ([info[UIImagePickerControllerMediaType] hasSuffix:@"image"]) {//资源类型为图片
        if (info[UIImagePickerControllerOriginalImage]) {
            self.imageView.image = info[UIImagePickerControllerOriginalImage];
        }
    }
}
@end
