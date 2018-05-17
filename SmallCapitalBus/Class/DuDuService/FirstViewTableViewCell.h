//
//  FirstViewTableViewCell.h
//  SmallCapitalBus
//
//  Created by ZY on 2018/4/10.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;

@end
