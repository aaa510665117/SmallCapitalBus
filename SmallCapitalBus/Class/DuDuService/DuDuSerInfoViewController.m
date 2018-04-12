//
//  DuDuSerInfoViewController.m
//  SmallCapitalBus
//
//  Created by ZY on 2018/4/12.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import "DuDuSerInfoViewController.h"

@interface DuDuSerInfoViewController ()

@end

@implementation DuDuSerInfoViewController

-(instancetype)init{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DuDuSerSB" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:@"DuDuSerInfoViewController"];
    if (self) {
        // Custom initialization
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.title = @"服务详情";
        navBackTitle(@"返回");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
