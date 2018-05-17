//
//  CkeckQRCodeViewController.m
//  SkyEmergency
//
//  Created by ZY on 16/2/16.
//  Copyright © 2016年 ZY. All rights reserved.
//

#import "CkeckQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
//#import "ZBarSDK.h"

@interface CkeckQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>  //ZBarReaderDelegate
{
    NSTimer *_timer;
    BOOL upOrdown;
    BOOL scan;;
    UIImageView *_QrCodeline;
}
@property ( strong , nonatomic ) AVCaptureDevice * device;
@property ( strong , nonatomic ) AVCaptureDeviceInput * input;
@property ( strong , nonatomic ) AVCaptureMetadataOutput * output;
@property ( strong , nonatomic ) AVCaptureSession * session;
@property ( strong , nonatomic ) AVCaptureVideoPreviewLayer * preview;

@property (weak, nonatomic) IBOutlet UIImageView *checkQRView;

@end

@implementation CkeckQRCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = CGRectMake(0, 0, UISCREEN_BOUNDS_SIZE.width, UISCREEN_BOUNDS_SIZE.height-64);
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"扫一扫";
    
//    //相册选择
//    UIButton * _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _photoBtn.tag = 100;
//    _photoBtn.frame = CGRectMake(0, 0, 40, 22);
//    _photoBtn.backgroundColor = [UIColor clearColor];
//    [_photoBtn setTitle:@"相册" forState:UIControlStateNormal];
//    [_photoBtn addTarget:self action:@selector(checkPhotoQR) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * photoBarItem = [[UIBarButtonItem alloc]initWithCustomView:_photoBtn];
//    self.navigationItem.rightBarButtonItem = photoBarItem;
    
    //检查相机权限
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        NSLog(@"相机权限受限");
        [ToolsFunction showPromptViewWithString:@"请在iPhone的“设置-隐私-相机”选项中，允许空中急救访问你的相机" background:nil timeDuration:5];
    }
    else
    {
        [self initAVCapture];
    }
    
    //绘制扫描区域
    [self drawCheckView];
}

-(void)initAVCapture
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    // Output
    _output = [[AVCaptureMetadataOutput alloc] init];
    [ _output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //这个CGRectMake(Y,X,H,W) 1代表最大值    原点是导航右下角 为起始点   上下左右各大10，方便进行扫描
    CGRect lensRect = CGRectMake(UISCREEN_BOUNDS_SIZE.width/2-250/2-10, self.view.frame.size.height/2-250/2-20-10, 270, 270);
    
    CGFloat screenW = UISCREEN_BOUNDS_SIZE.width;
    CGFloat screenH = UISCREEN_BOUNDS_SIZE.height;
    CGRect rectInterest = CGRectMake(CGRectGetMinY(lensRect) / screenH,
                                     ((screenW-CGRectGetWidth(lensRect)))/2/screenW,
                                     CGRectGetHeight(lensRect) / screenH,
                                     CGRectGetWidth(lensRect) / screenW);
    [ _output setRectOfInterest:rectInterest];
    
    // Session
    _session = [[AVCaptureSession alloc ] init];
    [ _session setSessionPreset : AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    // 条码类型 AVMetadataObjectTypeQRCode
    _output . metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    // Start
    [_session startRunning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self createTimer];
    [_session startRunning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopTimer];
}

-(void)drawCheckView
{
    //画中间的基准线
    upOrdown = NO;
    _QrCodeline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 250, 2)];
    _QrCodeline.image = [UIImage imageNamed:@"qrCode_line"];
    [_checkQRView addSubview:_QrCodeline];
}

- (void)animation
{
    if (scan) {
        [UIView animateWithDuration:2 animations:^{
            scan = NO;
            if (upOrdown == YES) {
                _QrCodeline.frame = CGRectMake(_QrCodeline.frame.origin.x, 248, _QrCodeline.frame.size.width, _QrCodeline.frame.size.height);
            }else {
                _QrCodeline.frame = CGRectMake(_QrCodeline.frame.origin.x, 2, _QrCodeline.frame.size.width, _QrCodeline.frame.size.height);
            }
        } completion:^(BOOL finished) {
            upOrdown = !upOrdown;
            scan = YES;
        }];
    }
}

- (void)createTimer
{
    scan = YES;
    //创建一个时间计数
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(animation) userInfo:nil repeats:YES];
}

- (void)stopTimer
{
    if ([_timer isValid] == YES) {
        [_timer invalidate];
        _timer =nil;
    }
}

//-(void)checkPhotoQR
//{
//    //从相册选择进行扫描
//    ZBarReaderController *reader = [ZBarReaderController new];
//    reader.showsHelpOnFail = NO;
//    reader.readerDelegate = self;
//    reader.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//
//    [self presentViewController:reader animated:YES completion:nil];
//}
//
////从相册进行选择扫描
//- (void)readerControllerDidFailToRead: (ZBarReaderController*)reader withRetry: (BOOL)retry
//{
//    if(retry)
//    {
//        //retry == YES 选择图片为非二维码
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您选择的二维码不正确,请重新选择" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//
//        if(![self.parentViewController isBeingDismissed]){
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }
//    }
//    else
//    {//if retry is NO,must dismiss the reader before returning
//        [reader dismissViewControllerAnimated:YES completion:nil];
//    }
//}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    UIImage *imageCurrent = (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
//
//    imageCurrent = nil;
//
//    // ADD: get the decode results
//    id<NSFastEnumeration> results =
//    [info objectForKey: ZBarReaderControllerResults];
//    ZBarSymbol *symbol = nil;
//    for (symbol in results)
//        break;
//
//    NSString *userID = [[symbol.data componentsSeparatedByString:@"?"]lastObject];
//
//    if(_checkType.length == 0)
//    {
//        //个人信息部分
//        if ([ToolsFunction isUserID:userID]) {
//            //个人信息界面
//            PersonInfoViewController * personInfo = [[PersonInfoViewController alloc]init];
//            personInfo.uid = userID;
//            personInfo.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:personInfo animated:YES];
//        }
//        else {
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您选择的二维码不正确,请重新选择" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
//        }
//    }
//    else
//    {
//        [self chekSignWithSignCode:symbol.data];
//    }
//
//    [picker dismissViewControllerAnimated:NO completion:nil];
//}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    
    if ([metadataObjects count ] > 0)
    {
        // 停止扫描
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0];
        stringValue = metadataObject. stringValue ;
        
        if ([ToolsFunction isOrderID:stringValue]) {
            //个人信息界面
            [_session stopRunning];
            
            //        __weak typeof(self) weakSelf = self;
            NSMutableDictionary * httpDic = [[NSMutableDictionary alloc]init];
            //    [httpDic setValue:[AppDelegate appDelegate].userProfile.userSession forKey:@"ss"];
            [httpDic setValue:SESSION forKey:@"ss"];
            [httpDic setValue:[[stringValue componentsSeparatedByString:@"_"] lastObject] forKey:@"order_id"];
            
            [[ZYHttpAPI sharedUpDownAPI]requestOrdinary:@"/api/v1/massagist/scan/start/service" withParams:httpDic withSuccess:^(NSDictionary *success) {
                
                [ToolsFunction hideHttpPromptView:nil];
                if([[success ac_stringForKey:HTTP_RETURN_KEY] isEqualToString:@"1"])
                {
                    [ToolsFunction showPromptViewWithString:@"扫码成功，服务开始" background:nil timeDuration:1];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [ZYHttpAPI analysisErrorCode:success withRequestAdd:@"/api/v1/massagist/scan/start/service"];
                }
                
            } withFailure:^(NSDictionary *failure) {
                
                [ToolsFunction showPromptViewWithString:NSLocalizedString(@"HTTP_SERVER_ERROR", nil) background:nil timeDuration:1];
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
