//
//  SignViewController.m
//  SmallCapitalBus
//
//  Created by ZY on 2018/4/12.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import "SignViewController.h"
#import "AFViewShaker.h"

@interface SignViewController ()

@property (weak, nonatomic) IBOutlet UITextField *mobelTextView;
@property (weak, nonatomic) IBOutlet UITextField *validateTextView;
@property (weak, nonatomic) IBOutlet UIButton *getValidateBtn;

@end

@implementation SignViewController

-(instancetype)init{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"StartSB" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:@"SignViewController"];
    if (self) {
        // Custom initialization
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
        
        navBackTitle(@"返回");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (IBAction)getValidateCodeClick:(id)sender {
    //获取验证码
    //短信验证码登录 点击获取验证码
    //点击注册按钮
    if(_mobelTextView.text.length != 11)
    {
        //手机号异常判断
        [ToolsFunction showPromptViewWithString:@"请输入11位手机号" background:nil timeDuration:1];
        return;
    }
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc]init];
    [httpDic setValue:_mobelTextView.text forKey:@"un"];
    
    [ToolsFunction showHttpPromptView:nil];
    [[ZYHttpAPI sharedUpDownAPI]requestOrdinary:@"login_note.php" withParams:httpDic withSuccess:^(NSDictionary *success) {
        
        [ToolsFunction hideHttpPromptView:nil];
        
        if([[success objectForKey:HTTP_RETURN_KEY] isEqualToString:@"1"])
        {
            //请求短信成功，开始读秒
            [self startTime];
        }
        else
        {
            [ZYHttpAPI analysisErrorCode:success withRequestAdd:@"login_note.php"];
        }
        
    } withFailure:^(NSDictionary *failure) {
        
        [ToolsFunction hideHttpPromptView:nil];
        
        [ToolsFunction showPromptViewWithString:NSLocalizedString(@"HTTP_SERVER_ERROR", nil) background:nil timeDuration:1];
    }];
}

//开始读秒
-(void)startTime{
    
    __weak typeof(self)weakSelf = self;
    __block int timeout=60; //倒计时时间
    //创建一个专门执行timer回调的GCD队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [weakSelf.getValidateBtn setTitleColor:[UIColor colorWithRed:45/255.0 green:150/255.0 blue:216/255.0 alpha:1.0] forState:UIControlStateNormal];
                [weakSelf.getValidateBtn setEnabled:YES];
                [weakSelf.getValidateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            });
        }else{
            int seconds = (timeout%60==0)?60:timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [weakSelf.getValidateBtn setTitle:[NSString stringWithFormat:@"%@S",strTime] forState:UIControlStateNormal];
                [weakSelf.getValidateBtn setTitleColor:[UIColor colorWithWhite:0.788 alpha:1.000] forState:UIControlStateNormal];
                [weakSelf.getValidateBtn setEnabled:NO];
                [UIView commitAnimations];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (IBAction)clickSignBtn:(id)sender {
    //点击登录
    NSMutableArray *views = [NSMutableArray array];
    //登录
    if([_mobelTextView.text isEqualToString:@""]) {
        [views addObject:_mobelTextView];
    }
    if([_validateTextView.text isEqualToString:@""]){
        [views addObject:_validateTextView];
    }
    if (views.count) {
        AFViewShaker *shaker = [[AFViewShaker alloc] initWithViewsArray:views];
        [shaker shake];
    }else {
        [AppDelegate appDelegate].userProfile.userAccountNumber = _mobelTextView.text;
        [[AppDelegate appDelegate].loginManager loginVerify:_validateTextView.text];
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
