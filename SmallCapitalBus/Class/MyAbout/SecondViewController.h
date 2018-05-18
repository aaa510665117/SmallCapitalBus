//
//  SecondViewController.h
//  SmallCapitalBus
//
//  Created by ZY on 2018/3/1.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondViewTableViewCell.h"

@interface SecondViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

