//
//  IQActionPickerViewOffice.m
//  SkyHospital
//
//  Created by Apple on 14-12-8.
//  Copyright (c) 2014年 GrayWang. All rights reserved.
//

#import "IQActionPickerViewOffice.h"
#import "AppDelegate.h"

#define SHOW_HIGHT         216   //UIPickerView 默认高度
#define TITLE_HIGHT        44


@implementation IQActionPickerViewOffice{
    
    NSArray * officeMap ;
    NSDictionary * allOfficeName;//的小科室名称
    NSArray * showComp2Number;//保存所选的comp1对应的comp2的科室编码
    NSMutableArray * firstCompArray ;
    NSMutableDictionary * componentDic;
    NSInteger selectedOffice;//选择的科室
    
}

@synthesize delegate;

-(id)initWithType:(IQActionPickerViewStyle) type{
    
    self = [super init];
    
    if (self) {
        
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"Management_of_health" ofType:@"plist"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
        officeMap = [dic objectForKey:@"DoctorOfficeMap"];
        firstCompArray = [officeMap objectAtIndex:0];
        allOfficeName = [officeMap objectAtIndex:2] ;
        componentDic  = [officeMap objectAtIndex:1];
        
        if (type == IQActionPickerViewForSetOffice) {
            
            [firstCompArray removeObjectAtIndex:0];
            [componentDic removeObjectForKey:@"不限"];
            
        }else if (type == IQActionPickerViewForSreech) {
            
            [allOfficeName setValue:@"不限" forKey:@"-1"];
            
        }
        
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.490];
        
        picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0 , self.frame.size.height-180, self.frame.size.width, 200)];
        picker.backgroundColor = [UIColor whiteColor];
        picker.delegate = self;
        picker.dataSource = self;
        picker.showsSelectionIndicator = YES;
        [self addSubview:picker];
        
        
        UIView *handView = [[UIView alloc]initWithFrame:CGRectMake(0, picker.frame.origin.y-TITLE_HIGHT, self.frame.size.width, TITLE_HIGHT)];
        handView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        
        UIButton *canceButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 50, 34)];
        canceButton.backgroundColor = [UIColor clearColor];
        [canceButton setTitle:@"取消" forState:UIControlStateNormal];
        [canceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [canceButton addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [handView addSubview:canceButton];
        
        UIButton *doneButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-55, 5, 50, 34)];
        doneButton.backgroundColor = [UIColor clearColor];
        [doneButton setTitle:@"确定" forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(doneClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [handView addSubview:doneButton];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(canceButton.frame.size.width+canceButton.frame.origin.x, 5, self.frame.size.width-doneButton.frame.size.width-canceButton.frame.size.width-10, 34)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.text = @"科室";
        
        [handView addSubview:titleLabel];
        
        [self addSubview:handView];
        
    }

    
    return self;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel * tilte = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width/2, 40)];
    
    tilte.numberOfLines = 0;
    tilte.lineBreakMode = 0;
    
    tilte.textAlignment = NSTextAlignmentCenter;
    tilte.font = [UIFont systemFontOfSize:16];

    
    switch (component) {
            
        case 0:
        {
            
            NSArray * oneTitleArray = firstCompArray;
            NSString * tilteStr = [oneTitleArray objectAtIndex:row];
            
            tilte.text = tilteStr;
            return tilte;
        }
            break;
        case 1:{
            
            
            NSString *totalOffice = [showComp2Number objectAtIndex:row] ;
            NSString * twoTilteStr =[allOfficeName objectForKey: totalOffice];
            
            tilte.text = twoTilteStr;
            
            return tilte;
        }
            break;
        default:
            break;
    }
    
    return nil;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
        {
            
            NSArray * component1 = firstCompArray;
            
            return component1.count;
        }
            break;
            case 1:
        {
            NSInteger selectedNumOfComp1 = [pickerView selectedRowInComponent:0];
            NSString * selectedStr = [firstCompArray objectAtIndex:selectedNumOfComp1];
            componentDic = [officeMap objectAtIndex:1];
            NSArray * component2 = [componentDic objectForKey:selectedStr];
            showComp2Number = component2;
            return component2.count;
        }
        default:
            break;
    }
    
    return 3;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 2;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    if (component == 0) {
        
        [pickerView reloadComponent:1];//1.先刷新组件
        [pickerView selectRow:0 inComponent:1 animated:YES];//2.设置选择行；
        
    }else{
        
        NSInteger totalOffice = [[showComp2Number objectAtIndex:row] integerValue];
        
        NSLog(@"%ld",totalOffice);
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component== 0) {
        
         return [UIScreen mainScreen].bounds.size.width*2/5;
        
    }else{
        
         return [UIScreen mainScreen].bounds.size.width*3/5;
    }
}


-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}



-(void)setPickerValue:(NSString *)selectNum
{
    
    selectedOffice = [selectNum integerValue];
    
   componentDic = [officeMap objectAtIndex:1];
   
    for (int compOneRow = 0; compOneRow <componentDic.count ; compOneRow++){
        
        NSString * selectedStr = [firstCompArray objectAtIndex:compOneRow];
        NSArray * arr = [componentDic objectForKey:selectedStr];
        
        for (int compTwoRow =0 ; compTwoRow < arr.count; compTwoRow++) {
            
            NSString * num = [arr objectAtIndex:compTwoRow];
            
            if ([num intValue] == [selectNum intValue]) {
                
                [picker selectRow:compOneRow inComponent:0 animated:NO];
                [picker reloadComponent:1];
                [picker selectRow:compTwoRow inComponent:1 animated:NO];
                
            }
            
        }
        
    }
    
}

//显示选择器
-(void)showOfficePickerView
{
    
    [[AppDelegate appDelegate].window addSubview:self];
}



//确定选择
-(void)doneClicked
{
    
    NSInteger compTwoRow =[picker selectedRowInComponent:1];
    NSString  *totalOffice = [showComp2Number objectAtIndex:compTwoRow];
    selectedOffice = [totalOffice integerValue];
    
    NSLog(@"%@ --- %@",totalOffice,[allOfficeName objectForKey:totalOffice]);
    
    if (self.viewStyle == IQActionPickerViewForTitleAndTag)
    {
        [self.delegate actionPickerView:self didSelectParameter:@{@"id":totalOffice,@"title":[allOfficeName objectForKey:totalOffice]}];
    }
    else
    {
    //代理方法
        [self.delegate actionPickerView:self didSelectTitle:totalOffice];
    }
    
    [self remove];
}


//取消选择
-(void)cancelClicked{
    
    [self remove];
}

//处理选择器外部的点击事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGFloat y = point.y;
    
    if (y < picker.frame.origin.y-TITLE_HIGHT) {
        [self remove];
    }
    
}

//移除选择器
- (void)remove
{
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0;
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
