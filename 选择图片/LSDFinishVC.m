//
//  LSDFinishVC.m
//  选择图片-单张
//
//  Created by SelenaWong on 17/2/16.
//  Copyright © 2017年 SelenaWong. All rights reserved.
//

#import "LSDFinishVC.h"
#import "LSDAssetTool.h"
@interface LSDFinishVC ()
@property (weak, nonatomic) IBOutlet UIButton *retakeBtn;
@property (weak, nonatomic) IBOutlet UIButton *usePhotoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@end

@implementation LSDFinishVC
//初始化
- (instancetype)initWithImage:(UIImage *)image{
    if (self == [super init]) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if (storyBoard) {
            self = [storyBoard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
            self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            _image = image;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = self.image;
}

- (IBAction)retakeBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)usePhotoBtnClick:(UIButton *)sender {
    if (self.imageView.image) {
        [self saveImageToAlbum:self.imageView.image];
        if (self.finishBlock) {
            self.finishBlock(self.imageView.image);
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 保存图片到相机胶卷
 */
- (void)saveImageToAlbum:(UIImage *)image{
    //获取当前图库权限状态
    PHAuthorizationStatus oldStatus = [LSDAssetTool getPhotoLibraryAuthorizationStatus];
    //检查访问权限
    [LSDAssetTool checkAutorizationStatusComplete:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusRestricted) {
            NSLog(@"因系统原因,无法访问相册权限");
        }else if (status == PHAuthorizationStatusAuthorized){//用户已授权访问相册
            [LSDAssetTool saveImageToAlbum:image complete:^(UIImage *saveImage, NSString *errorStr) {
                if (errorStr) {
                    NSLog(@"保存图片失败:%@",errorStr);
                }
            }];
        }else if (status == PHAuthorizationStatusDenied && oldStatus != PHAuthorizationStatusNotDetermined){//用户拒绝打开相册权限
            NSLog(@"请前往设置-隐私-图片重新打开相册访问权限开关");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
