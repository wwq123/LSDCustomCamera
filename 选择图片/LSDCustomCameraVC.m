//
//  LSDCustomCameraVC.m
//  选择图片-单张
//
//  Created by SelenaWong on 17/2/16.
//  Copyright © 2017年 SelenaWong. All rights reserved.
//

#import "LSDCustomCameraVC.h"
#import "LLSimpleCamera.h"
#import "LSDFinishVC.h"
@interface LSDCustomCameraVC ()
/**关闭按钮*/
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
/**拍照按钮*/
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
/**摄像头前置后置切换按钮*/
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;
/**闪光灯按钮*/
@property (weak, nonatomic) IBOutlet UIButton *flashBtn;
@property (nonatomic, strong) LLSimpleCamera *camera;
@end

@implementation LSDCustomCameraVC

//初始化
- (instancetype)init{
    if (self == [super init]) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if (storyBoard) {
            self = [storyBoard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initCamera];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.camera start];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.camera.view.frame = self.view.frame;
}

- (void)initUI{
    [self.flashBtn setBackgroundColor:[UIColor clearColor]];
}
/*
 初始化相机
 */
- (void)initCamera{
    __weak typeof(self) weakSelf = self;
    //打开捕获设备的回调
    [self.camera setOnDeviceChange:^(LLSimpleCamera *simpleCamera, AVCaptureDevice *device) {
        if ([simpleCamera isFlashAvailable]) {//判断系统设备是否支持闪光灯
            weakSelf.flashBtn.hidden = NO;
            if (simpleCamera.flash == LLCameraFlashOff) {//设备支持闪光灯，再判断当前闪光灯的状态
                weakSelf.flashBtn.selected = NO;
            }else{
                weakSelf.flashBtn.selected = YES;
            }
        }else{
            weakSelf.flashBtn.hidden = YES;
        }
    }];
    
    if ([LLSimpleCamera isFrontCameraAvailable] && [LLSimpleCamera isRearCameraAvailable]) {//判断设备是否支持前置后置摄像头
        self.switchBtn.hidden = NO;
    }else{
        self.switchBtn.hidden = YES;
    }
    
    //错误回调
    [self.camera setOnError:^(LLSimpleCamera *simpleCamera, NSError *error) {
        if (error) {
            if ([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
                if (error.code == LLSimpleCameraErrorCodeCameraPermission) {//未获取相机权限
                    if (weakSelf.captureFinishedBlock) {
                        weakSelf.captureFinishedBlock(nil,error);
                    }
                }
            }
        }
    }];
    
    [self.view sendSubviewToBack:self.camera.view];
}
#pragma mark - 按钮点击方法
/*
 退出相机
 */
- (IBAction)closeBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 拍照
 */
- (IBAction)cameraBtnClick:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
        if (!error) {
            LSDFinishVC *finishVC = [[LSDFinishVC alloc] initWithImage:image];
            finishVC.finishBlock = ^(UIImage *useImage){
                weakSelf.view.alpha = 0;
                [weakSelf dismissViewControllerAnimated:NO completion:nil];
                if (weakSelf.captureFinishedBlock) {
                    weakSelf.captureFinishedBlock(image,nil);
                }
            };
            [weakSelf presentViewController:finishVC animated:YES completion:nil];
        }else{
            if (weakSelf.captureFinishedBlock) {
                weakSelf.captureFinishedBlock(nil,error);
            }
        }
    } exactSeenImage:YES];
}

/*
 切换摄像头
 */
- (IBAction)switchBtnClick:(UIButton *)sender {
    [self.camera togglePosition];
}

/*
 开关闪光灯
 */
- (IBAction)flashBtnClick:(UIButton *)sender {
    if (self.camera.flash == LLCameraFlashOff) {//当前闪光灯是关闭状态
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOn];//打开
        if (done) {
            [self.flashBtn setBackgroundColor:[UIColor yellowColor]];
            self.flashBtn.selected = YES;
        }
    }else{//当前闪光灯是开启状态
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOff];//关闭
        if (done) {
            [self.flashBtn setBackgroundColor:[UIColor clearColor]];
            self.flashBtn.selected = NO;
        }
    }
}

#pragma mark - 懒加载
- (LLSimpleCamera *)camera{
    if (_camera == nil) {
        //创建一个相机
        _camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh position:LLCameraPositionRear videoEnabled:YES];
        //添加到self上
        [_camera attachToViewController:self withFrame:CGRectZero];
        //图像捕获后是否固定图像方向
        _camera.fixOrientationAfterCapture = NO;
    }
    return _camera;
}
@end
