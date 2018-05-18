//
//  UserBasicSetViewController.m
//  SkyEmergency
//
//  Created by ZY on 15/11/4.
//  Copyright © 2015年 ZY. All rights reserved.
//

#import "UserBasicSetViewController.h"
#import "CommonChoseCityPickerView.h"
#import "AreaManager.h"
#import "UserProfile.h"

@interface UserBasicSetViewController ()
{
    NSArray * titleArray;
    AreaManager * areaManager;
    BOOL isViewWillAppear;
}

@property(nonatomic, strong)UITableView * myTableView;
@property(nonatomic, strong)UserProfileTable * userProfile;
@property(nonatomic, strong)UIButton * pubBtn;

@end

@implementation UserBasicSetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"个人信息";
    navBackTitle(@"返回");

    _userProfile = [UserProfileTable getUserProfileTableWithUID:[AppDelegate appDelegate].userProfile.userID];

    // Do any additional setup after loading the view.
    titleArray = [[NSArray alloc]initWithObjects:@"头像", @"姓名", @"性别", @"出生日期",@"出生地", @"所在地区", @"详细地址", nil];
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _myTableView.backgroundColor = [UIColor clearColor];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    
    //完成按钮
    _pubBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _pubBtn.tag = 100;
    _pubBtn.frame = CGRectMake(0, 0, 40, 22);
    _pubBtn.backgroundColor = [UIColor clearColor];
    [_pubBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_pubBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_pubBtn addTarget:self action:@selector(clickDoneAll) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * pubBarItem = [[UIBarButtonItem alloc]initWithCustomView:_pubBtn];
    self.navigationItem.rightBarButtonItem = pubBarItem;
    
    areaManager = [AreaManager shareAreaManager];
    
    isViewWillAppear = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if(isViewWillAppear == NO)
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        }
        
        //刷新一下个人信息
        [[AppDelegate appDelegate].userInfo getUserProfile:[AppDelegate appDelegate].userProfile.userID withPiv:nil withSuccessBlock:^(UserProfileTable *userInfo) {
            
        } withFail:^{
            
        }];
        
        isViewWillAppear = YES;
    }
}

//点击完成按钮
-(void)clickDoneAll
{
    //进行登录
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc]init];
    [httpDic setValue:[AppDelegate appDelegate].userProfile.userSession forKey:@"ss"];
    [httpDic setValue:_userProfile.name forKey:@"name"];
    [httpDic setValue:_userProfile.sex_id forKey:@"sex"];
    [httpDic setValue:_userProfile.birthday forKey:@"birthday"];
    [httpDic setValue:_userProfile.birth_place forKey:@"birth_place"];
    [httpDic setValue:_userProfile.live_province_id forKey:@"live_place"];
    [httpDic setValue:_userProfile.live_place forKey:@"live_placeinfo"];
    
    [ToolsFunction showHttpPromptView:nil];
    
    __weak typeof (self) weakSelf = self;
    [[ZYHttpAPI sharedUpDownAPI]requestOrdinary:@"api/ysbt/user/update/profile" withParams:httpDic withSuccess:^(NSDictionary *success) {
        
        [ToolsFunction hideHttpPromptView:nil];
        
        if([[success objectForKey:HTTP_RETURN_KEY] isEqualToString:@"1"])
        {
            //修改成功
            NSDictionary *resultDic = [success objectForKey:HTTP_RETURN_RESULT];
            NSString * piv = [resultDic objectForKey:@"piv"];
            weakSelf.userProfile.base_ver = piv;
            [weakSelf.userProfile updateToDB];      //更新数据库
            [AppDelegate appDelegate].userProfile.userProfileVersion = piv;
            [weakSelf.pubBtn setEnabled:NO];
            [weakSelf.pubBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            //更新个人信息plist文件
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:piv forKey:@"ProfileVersion"];
            [defaults synchronize];
            
            [ToolsFunction showPromptViewWithString:@"修改成功" background:nil timeDuration:1];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            [ZYHttpAPI analysisErrorCode:success withRequestAdd:@"api/ysbt/user/update/profile"];
        }
        
    } withFailure:^(NSDictionary *failure) {
        
        [ToolsFunction hideHttpPromptView:nil];
        
        [ToolsFunction showPromptViewWithString:NSLocalizedString(@"HTTP_SERVER_ERROR", nil) background:nil timeDuration:1];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 65;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * Identifier = @"cell";
    UITableViewCell * cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:Identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
        UIImageView * userImage = [[UIImageView alloc]init];
        userImage.backgroundColor = [UIColor clearColor];
        userImage.tag = 200;
        userImage.hidden = YES;

        [cell.contentView addSubview:userImage];
    }
    
    cell.textLabel.text = [titleArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    UIImageView * userImage = (UIImageView *)[cell.contentView viewWithTag:200];

    switch (indexPath.row) {
        case 0:
        {
            userImage.frame = CGRectMake(UISCREEN_BOUNDS_SIZE.width-50, 65/2-20, 40, 40);
            userImage.layer.cornerRadius = 20;
            userImage.layer.masksToBounds = YES;
            userImage.hidden = NO;
            cell.detailTextLabel.hidden = YES;
            [userImage getAvatarThumbnailWithURL:_userProfile.thumbnail_image_url];
        }
            break;
        case 1:
        {
            userImage.hidden = YES;
            cell.detailTextLabel.hidden = NO;
            cell.detailTextLabel.text = _userProfile.name;                                                   //姓名
        }
            break;
        case 2:
        {
            userImage.hidden = YES;
            cell.detailTextLabel.hidden = NO;
            cell.detailTextLabel.text = [[AppDelegate appDelegate].userInfo getUserGender:_userProfile.sex_id]; //性别
        }
            break;
        case 3:
        {
            userImage.hidden = YES;
            cell.detailTextLabel.hidden = NO;
            cell.detailTextLabel.text = _userProfile.birthday;                                               //生日
        }
            break;
        case 4:
        {
            userImage.hidden = YES;
            cell.detailTextLabel.hidden = NO;
            NSString * birthAreaStr = [areaManager getPCAName:_userProfile.birth_place];
            cell.detailTextLabel.text = birthAreaStr;                                                        //出生地
        }
            break;
        case 5:
        {
            userImage.hidden = YES;
            cell.detailTextLabel.hidden = NO;
            NSString * areaStr = [areaManager getPCAName:_userProfile.live_province_id];
            cell.detailTextLabel.text = areaStr;                                                            //现居住地
        }
            break;
        case 6:
        {
            userImage.hidden = YES;
            cell.detailTextLabel.hidden = NO;
            cell.detailTextLabel.text = _userProfile.live_place;                                        //现居住地详情
        }
            break;
        default:
            break;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            //头像
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择图片来源"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //相机
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                imagePicker.allowsEditing = YES;
                [[ToolsFunction getCurrentRootViewController] presentViewController:imagePicker animated:YES completion:^{}];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"本地照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //相册
                UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                }
                UIImagePickerController * picker = [[UIImagePickerController alloc]init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = sourceType;
                [[ToolsFunction getCurrentRootViewController] presentViewController:picker animated:YES completion:^{}];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            //弹出提示框；
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        case 1:
        {
            //姓名
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请填写姓名"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                // 可以在这里对textfield进行定制，例如改变背景色
                textField.text = _userProfile.name;

                if ([ToolsFunction isOnlyChineseAndAbcAndNum:textField.text]) {
                    [ToolsFunction showPromptViewWithString:@"只含有汉字、数字和字母" background:nil timeDuration:2];
                    return ;
                }
                //判断文字长度
                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                NSData* data = [textField.text dataUsingEncoding:enc];
                if (data.length>24)
                {
                    [ToolsFunction showPromptViewWithString:@"不能输入过多文字哦~" background:nil timeDuration:1];
                    [textField resignFirstResponder];
                    return ;
                }
                //success
                if ([textField.text length])
                {
                    _userProfile.name = textField.text;
                    NSIndexPath *indexPath_2=[NSIndexPath indexPathForRow:1 inSection:0];
                    [_myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath_2] withRowAnimation:UITableViewRowAnimationMiddle];
                    [_pubBtn setEnabled:YES];
                    [_pubBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                }
                else
                {
                    [ToolsFunction showPromptViewWithString:@"请填写姓名" background:nil timeDuration:1];
                }
            }];

            //弹出提示框；
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        case 2:
        {
            //性别
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择性别"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //男
                _userProfile.sex_id = @"1";
                NSIndexPath *indexPath_3=[NSIndexPath indexPathForRow:2 inSection:0];
                [_myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath_3] withRowAnimation:UITableViewRowAnimationMiddle];
                [_pubBtn setEnabled:YES];
                [_pubBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //女
                _userProfile.sex_id = @"2";
                NSIndexPath *indexPath_3=[NSIndexPath indexPathForRow:2 inSection:0];
                [_myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath_3] withRowAnimation:UITableViewRowAnimationMiddle];
                [_pubBtn setEnabled:YES];
                [_pubBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            //弹出提示框；
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        case 3:
        {
            //出生日期
            NSString *string = [[_userProfile.birthday componentsSeparatedByString:@":"]objectAtIndex:0];
            NSArray *array = [string componentsSeparatedByString:@"-"];
            NSArray *array1 = [[array objectAtIndex:2] componentsSeparatedByString:@" "];
            NSInteger one = [[array objectAtIndex:0] integerValue] - 1900;
            NSInteger two = [[array objectAtIndex:1] integerValue] - 1;
            NSInteger three = [[array1 objectAtIndex:0] integerValue] - 1;
            
            IQActionView *actionView = [[IQActionView alloc]initWithTitle:@"出生日期" withActionStyle:IQActionViewStyleDatePicker withDelegate:self];
            actionView.tag = 5002;
            actionView.selectRowOne = one;
            actionView.selectRowTwo = two;
            actionView.selectRowThree = three;
            [actionView showInView:[AppDelegate appDelegate].window];
        }
            break;
        case 4:
        {
            //出生地
            __weak typeof (self) vc = self;
            CommonChoseCityPickerView * birthChoseCityView = [[CommonChoseCityPickerView alloc]initWithFrame:CGRectMake(0, 0, UISCREEN_BOUNDS_SIZE.width, UISCREEN_BOUNDS_SIZE.height)];
            birthChoseCityView.clickUpdateArea = ^(NSDictionary *areaID, NSString *areaStr){
                _userProfile.birth_place = [areaID objectForKey:@"areaID"];
                NSIndexPath *indexPath_5 = [NSIndexPath indexPathForRow:4 inSection:0];
                [vc.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath_5,nil] withRowAnimation:UITableViewRowAnimationMiddle];
                [vc.pubBtn setEnabled:YES];
                [vc.pubBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            };
            [birthChoseCityView show];
        }
            break;
        case 5:
        {
            //现居住地
            __weak typeof (self) vc = self;
            CommonChoseCityPickerView * choseCityView = [[CommonChoseCityPickerView alloc]initWithFrame:CGRectMake(0, 0, UISCREEN_BOUNDS_SIZE.width, UISCREEN_BOUNDS_SIZE.height)];
            choseCityView.clickUpdateArea = ^(NSDictionary *areaID, NSString *areaStr){
                
                _userProfile.live_place = [areaID objectForKey:@"areaID"];
                NSIndexPath *indexPath_6=[NSIndexPath indexPathForRow:5 inSection:0];
                [vc.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath_6] withRowAnimation:UITableViewRowAnimationMiddle];
                [vc.pubBtn setEnabled:YES];
                [vc.pubBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            };
            [choseCityView show];
        }
            break;
        case 6:
        {
            //现居住地详情
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请填写详细地址"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                // 可以在这里对textfield进行定制，例如改变背景色
                textField.text = _userProfile.live_place;
                //判断文字长度
                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                NSData* data = [textField.text dataUsingEncoding:enc];
                if (data.length>24)
                {
                    [ToolsFunction showPromptViewWithString:@"不能输入过多文字哦~" background:nil timeDuration:1];
                    [textField resignFirstResponder];
                    return ;
                }
                //success
                if ([textField.text length])
                {
                    _userProfile.live_place = textField.text;
                    NSIndexPath *indexPath_7=[NSIndexPath indexPathForRow:6 inSection:0];
                    [_myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath_7] withRowAnimation:UITableViewRowAnimationMiddle];
                    [_pubBtn setEnabled:YES];
                    [_pubBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                }
                else
                {
                    [ToolsFunction showPromptViewWithString:@"请填写详细地址" background:nil timeDuration:1];
                }
            }];
            
            //弹出提示框；
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark IQActionViewDelegate
- (void)actionView:(IQActionView *)pickerView didSelectTitles:(NSArray *)titles
{
    switch (pickerView.tag) {
        case 5002:  //出生日期
        {
            NSDate *now =[NSDate date];
            if ([self compareOneDay:now withAnotherDay:[titles firstObject]]==1) {
                _userProfile.birthday = [titles objectAtIndex:0];
                NSIndexPath *indexPath_4=[NSIndexPath indexPathForRow:3 inSection:0];
                [_myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath_4] withRowAnimation:UITableViewRowAnimationMiddle];
                [_pubBtn setEnabled:YES];
                [_pubBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            }else{
                [ToolsFunction showPromptViewWithString:@"输入不正确，请输入正确出生日期" background:nil timeDuration:1];
            }
           
        }
            break;
        default:
            break;
    }
}

//比较出生日期
- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSString *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDay];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending){
        return 1;
    }
    else if (result == NSOrderedAscending){
        return -1;
    }
    return 0;
    
}
#pragma mark imagePickerDelegte
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker popViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //上传图像
    [self uploadUserImageToServer:image];
    
    [picker dismissViewControllerAnimated:YES
                               completion:nil];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)uploadUserImageToServer:(UIImage *)image
{
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    [param setValue:[AppDelegate appDelegate].userProfile.userSession forKey:@"ss"];
    
    [ToolsFunction showHttpPromptView:nil];
    [[ZYHttpAPI sharedUpDownAPI] uploadFile:@"api/ysbt/user/update/avatar"
                                   withFile:image
                                  withParam:param
                                       name:@"file"
                                   fileName:[NSString stringWithFormat:@"%@.jpg",[AppDelegate appDelegate].userProfile.userID]
                               successBlock:^(NSDictionary *success) {
                                   [ToolsFunction hideHttpPromptView:nil];

                                   if([[success objectForKey:HTTP_RETURN_KEY] isEqualToString:@"1"])
                                   {
                                       //上传成功
                                       NSDictionary *resultDic = [success objectForKey:HTTP_RETURN_RESULT];
                                       _userProfile.thumbnail_image_url = [resultDic objectForKey:@"thumbnail_image_url"];
                                       [_userProfile updateToDB];      //更新数据库
                                       NSIndexPath *indexPath_0=[NSIndexPath indexPathForRow:0 inSection:0];
                                       [_myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath_0] withRowAnimation:UITableViewRowAnimationMiddle];
                                       [ToolsFunction showPromptViewWithString:@"修改成功" background:nil timeDuration:1];
                                   }
                                   else
                                   {
                                       [ZYHttpAPI analysisErrorCode:success withRequestAdd:@"api/ysbt/user/update/avatar"];
                                   }
                               } failureBlock:^(NSDictionary *failure) {

                                   [ToolsFunction hideHttpPromptView:nil];

                                   [ToolsFunction showPromptViewWithString:NSLocalizedString(@"HTTP_SERVER_ERROR", nil) background:nil timeDuration:1];
                               }];
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
