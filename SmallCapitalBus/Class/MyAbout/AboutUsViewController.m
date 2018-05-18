//
//  AboutUsViewController.m
//  SkyClinic
//
//
//  Created by zhu_sl on 2018/4/12.
//  Copyright © 2018年 DMZY. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@property (strong, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation AboutUsViewController

-(instancetype)init{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SecondSB" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:@"AboutUsViewController"];
    if (self) {
        // Custom initialization
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.title = @"关于我们";
        navBackTitle(@"返回");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于我们";
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    _versionLabel.text = [NSString stringWithFormat:@"  V%@  ",appVersion];
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
