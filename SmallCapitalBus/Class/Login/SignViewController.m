//
//  SignViewController.m
//  SmallCapitalBus
//
//  Created by ZY on 2018/4/12.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import "SignViewController.h"

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
}

- (IBAction)clickSignBtn:(id)sender {
    //点击登录
    [[AppDelegate appDelegate] showMainTabNav];
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
