//
//  AreaManager.m
//  SkyEmergency
//
//  Created by ZY on 15/10/13.
//  Copyright © 2015年 ZY. All rights reserved.
//

#import "AreaManager.h"
#import <sqlite3.h>

#define Assert(cond, ...) do { if (!(cond)) { printf(__VA_ARGS__); assert(cond); } } while(0)
static	sqlite3_stmt	*get_province_statement = nil;
static	sqlite3_stmt	*get_city_statement = nil;
static	sqlite3_stmt	*get_area_statement = nil;
static  AreaManager * areaManager;

@interface AreaManager()
{
    sqlite3 * database;
}
@property(nonatomic, retain)NSMutableArray *provinceNameArray;
@property(nonatomic, retain)NSMutableArray *provinceIDArray;
@property(nonatomic, retain)NSMutableArray *cityNameArray;
@property(nonatomic, retain)NSMutableArray *cityIDArray;
@property(nonatomic, retain)NSMutableArray *cityFatherArray;
@property(nonatomic, retain)NSMutableArray *areaNameArray;
@property(nonatomic, retain)NSMutableArray *areaIDArray;
@property(nonatomic, retain)NSMutableArray *areaFatherArray;

@end

@implementation AreaManager

+(AreaManager *)shareAreaManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        areaManager=[[AreaManager alloc] init];
    });
    return areaManager;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        areaManager = [super allocWithZone:zone];
    });
    return areaManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        if ([self OpenDatabase]) {
            [self GetInfoFromTableProvice:database];
            [self GetInfoFromTableCity:database];
            [self GetInfoFromTableArea:database];
        }
    }
    return self;
}

//打开数据库
- (BOOL)OpenDatabase
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"place" ofType:@"db"];
    NSLog(@"path %@",path);
    
    if(sqlite3_open([path UTF8String], &database) == SQLITE_OK){
        NSLog(@"open database success");
        return YES;
    }
    else{
        sqlite3_close(database);
        NSLog(@"Error: open database file.");
        
        return NO;
    }
    return NO;
}

//取得hat_provice表中数据
- (void)GetInfoFromTableProvice:(sqlite3*)_database
{
    if(get_province_statement == nil){
        const char *sql = "select * from province";
        
        if (sqlite3_prepare_v2(_database, sql, -1, &get_province_statement, NULL) != SQLITE_OK){
            Assert(0, "Error: failed to prepare province with message '%s'.", sqlite3_errmsg(database));
        }
    }
    while(sqlite3_step(get_province_statement) == SQLITE_ROW){
        if (_provinceNameArray == nil){
            _provinceNameArray    = [[NSMutableArray alloc] init];
        }
        [_provinceNameArray addObject:[NSString  stringWithUTF8String:(char*) sqlite3_column_text(get_province_statement, 2)]];
        if (_provinceIDArray == nil){
            _provinceIDArray    = [[NSMutableArray alloc] init];
        }
        [_provinceIDArray   addObject:[NSString  stringWithUTF8String:(char*) sqlite3_column_text(get_province_statement, 1)]];
    }
    sqlite3_reset(get_province_statement);
}

//取得hat_city表中数据
-(void) GetInfoFromTableCity:(sqlite3*)_database{
    if(get_city_statement == nil){
        const char *sql = "select * from city";
        
        if (sqlite3_prepare_v2(_database, sql, -1, &get_city_statement, NULL) != SQLITE_OK){
            Assert(0, "Error: failed to prepare city with message '%s'.", sqlite3_errmsg(database));
        }
    }
    while(sqlite3_step(get_city_statement) == SQLITE_ROW){
        if (_cityNameArray == nil){
            _cityNameArray    = [[NSMutableArray alloc] init];
        }
        [_cityNameArray addObject:[NSString  stringWithUTF8String:(char*) sqlite3_column_text(get_city_statement, 2)]];
        if (_cityIDArray == nil) {
            _cityIDArray      = [[NSMutableArray alloc] init];
        }
        [_cityIDArray addObject:[NSString  stringWithUTF8String:(char*) sqlite3_column_text(get_city_statement, 1)]];
        if (_cityFatherArray == nil) {
            _cityFatherArray      = [[NSMutableArray alloc] init];
        }
        [_cityFatherArray addObject:[NSString  stringWithUTF8String:(char*) sqlite3_column_text(get_city_statement, 3)]];
    }
    sqlite3_reset(get_city_statement);
}

//取得hat_area表中数据
-(void) GetInfoFromTableArea:(sqlite3*)_database{
    if(get_area_statement == nil){
        const char *sql = "select * from area";
        
        if (sqlite3_prepare_v2(_database, sql, -1, &get_area_statement, NULL) != SQLITE_OK){
            Assert(0, "Error: failed to prepare area with message '%s'.", sqlite3_errmsg(database));
        }
    }
    while(sqlite3_step(get_area_statement) == SQLITE_ROW){
        if (_areaIDArray == nil){
            _areaIDArray    = [[NSMutableArray alloc] init];
        }
        [_areaIDArray addObject:[NSString  stringWithUTF8String:(char*) sqlite3_column_text(get_area_statement, 1)]];
        
        if (_areaNameArray == nil) {
            _areaNameArray      = [[NSMutableArray alloc] init];
        }
        [_areaNameArray addObject:[NSString  stringWithUTF8String:(char*) sqlite3_column_text(get_area_statement, 2)]];
        if (_areaFatherArray == nil) {
            _areaFatherArray      = [[NSMutableArray alloc] init];
        }
        [_areaFatherArray addObject:[NSString  stringWithUTF8String:(char*) sqlite3_column_text(get_area_statement, 3)]];
    }
    sqlite3_reset(get_area_statement);
}

//关闭数据库
- (void)CloseDatabase
{
    sqlite3_close(database);
}

#pragma mark ---
#pragma mark DataMethod

//获取所有省份
- (NSArray *)getAllProvince
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.provinceIDArray.count; i ++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:[self.provinceIDArray objectAtIndex:i] forKey:@"ID"];
        [dic setObject:[self.provinceNameArray objectAtIndex:i] forKey:@"Name"];
        
        [arr addObject:dic];
    }
    
    return [[NSArray alloc]initWithArray:arr];
}

//获取省份所有城市
- (NSArray *)getAllCity:(NSString *)proviceID
{
    if (proviceID == nil) {
        return nil;
    }
    const char *sql = [[NSString stringWithFormat:@"select * from city where father = %@",proviceID] UTF8String];
    
    if (sqlite3_prepare_v2(database, sql, -1, &get_city_statement, NULL) != SQLITE_OK){
        Assert(0, "Error: failed to prepare city with message '%s'.", sqlite3_errmsg(database));
    }
    
    NSMutableArray *cityNameArrayTemp    = [[NSMutableArray alloc] init];
    NSMutableArray *cityIDArrayTemp      = [[NSMutableArray alloc] init];
    NSMutableArray *cityFatherArrayTemp  = [[NSMutableArray alloc] init];
    
    while(sqlite3_step(get_city_statement) == SQLITE_ROW){
        
        [cityNameArrayTemp addObject:[NSString  stringWithUTF8String:(char*) sqlite3_column_text(get_city_statement, 2)]];
        
        [cityIDArrayTemp addObject:[NSString  stringWithUTF8String:(char*) sqlite3_column_text(get_city_statement, 1)]];
        
        [cityFatherArrayTemp addObject:[NSString  stringWithUTF8String:(char*) sqlite3_column_text(get_city_statement, 3)]];
    }
    sqlite3_reset(get_city_statement);
    
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < cityIDArrayTemp.count; i ++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:[cityIDArrayTemp objectAtIndex:i] forKey:@"ID"];
        [dic setObject:[cityNameArrayTemp objectAtIndex:i] forKey:@"Name"];
        [dic setObject:[cityFatherArrayTemp objectAtIndex:i] forKey:@"Father"];
        
        [arr addObject:dic];
    }
    
    return [NSArray arrayWithArray:arr];
}

//获取城市所有区域
- (NSArray *)getAllArea:(NSString *)cityID
{
    if (cityID == nil) {
        return nil;
    }
    const char *sql = [[NSString stringWithFormat:@"select * from area where father = %@",cityID] UTF8String];
    
    if (sqlite3_prepare_v2(database, sql, -1, &get_area_statement, NULL) != SQLITE_OK){
        Assert(0, "Error: failed to prepare city with message '%s'.", sqlite3_errmsg(database));
    }
    
    NSMutableArray *areaIDArrayTemp      = [[NSMutableArray alloc] init];
    NSMutableArray *areaNameArrayTemp    = [[NSMutableArray alloc] init];
    NSMutableArray *areaFatherArrayTemp  = [[NSMutableArray alloc] init];
    
    while(sqlite3_step(get_area_statement) == SQLITE_ROW){
        
        [areaIDArrayTemp addObject:[NSString  stringWithUTF8String:(char*) sqlite3_column_text(get_area_statement, 1)]];
        
        [areaNameArrayTemp addObject:[NSString  stringWithUTF8String:(char*) sqlite3_column_text(get_area_statement, 2)]];
        
        [areaFatherArrayTemp addObject:[NSString  stringWithUTF8String:(char*) sqlite3_column_text(get_area_statement, 3)]];
    }
    sqlite3_reset(get_area_statement);
    
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < areaIDArrayTemp.count; i ++) {
        
        if([[areaNameArrayTemp objectAtIndex:i] isEqualToString:@"市辖区"] || [[areaNameArrayTemp objectAtIndex:i] isEqualToString:@"县"])
        {
            continue;
        }
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:[areaIDArrayTemp objectAtIndex:i] forKey:@"ID"];
        [dic setObject:[areaNameArrayTemp objectAtIndex:i] forKey:@"Name"];
        [dic setObject:[areaFatherArrayTemp objectAtIndex:i] forKey:@"Father"];
        
        [arr addObject:dic];
    }
    
    return [NSArray arrayWithArray:arr];
}

//判断一个id代表什么类型的id (0==无类型 1==省份id  2==市id  3==区id)
- (NSString *)isTypeID:(NSString *)areaID;
{
    if(areaID == nil || [areaID isEqualToString:@""] || areaID.length != 6)
    {
        return @"0";
    }
    NSString *cityStr = [areaID substringWithRange:NSMakeRange(2, 2)];
    NSString *areaStr = [areaID substringWithRange:NSMakeRange(4, 2)];

    if([cityStr isEqualToString:@"00"])
    {
        return @"1";
    }
    else if([areaStr isEqualToString:@"00"])
    {
        return @"2";
    }
    else
    {
        return @"3";
    }
}

//根据省份ID 获取省份信息
- (NSDictionary *)getProvinceInfo:(NSString *)provinceID
{
    if (provinceID == nil) {
        return nil;
    }
    const char *sql = [[NSString stringWithFormat:@"select * from province where provinceID = %@",provinceID] UTF8String];
    
    if (sqlite3_prepare_v2(database, sql, -1, &get_province_statement, NULL) != SQLITE_OK){
        Assert(0, "Error: failed to prepare province with message '%s'.", sqlite3_errmsg(database));
    }
    
    NSMutableArray *provinceNameArrayTemp    = [[NSMutableArray alloc] init];
    NSMutableArray *provinceIDArrayTemp      = [[NSMutableArray alloc] init];
    
    while(sqlite3_step(get_province_statement) == SQLITE_ROW){
        
        [provinceNameArrayTemp addObject:[NSString  stringWithUTF8String:(char*) sqlite3_column_text(get_province_statement, 2)]];
        
        [provinceIDArrayTemp addObject:[NSString  stringWithUTF8String:(char*) sqlite3_column_text(get_province_statement, 1)]];
        
    }
    sqlite3_reset(get_province_statement);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if(provinceIDArrayTemp.count == 0)
    {
        [dic setObject:provinceID   forKey:@"ID"];
        [dic setObject:provinceID   forKey:@"Name"];
        return dic;
    }
    [dic setObject:[provinceIDArrayTemp objectAtIndex:0]   forKey:@"ID"];
    [dic setObject:[provinceNameArrayTemp objectAtIndex:0]     forKey:@"Name"];
    
    return dic;
}

//根据城市ID 获取城市名称
- (NSDictionary *)getCityInfo:(NSString *)cityID
{
    if (cityID == nil) {
        return nil;
    }
    const char *sql = [[NSString stringWithFormat:@"select * from city where cityID = %@",cityID] UTF8String];
    
    if (sqlite3_prepare_v2(database, sql, -1, &get_city_statement, NULL) != SQLITE_OK){
        Assert(0, "Error: failed to prepare city with message '%s'.", sqlite3_errmsg(database));
    }
    
    NSMutableArray *cityNameArrayTemp    = [[NSMutableArray alloc] init];
    NSMutableArray *cityIDArrayTemp      = [[NSMutableArray alloc] init];
    NSMutableArray *cityFatherArrayTemp  = [[NSMutableArray alloc] init];
    
    while(sqlite3_step(get_city_statement) == SQLITE_ROW){
        
        [cityNameArrayTemp addObject:[NSString  stringWithUTF8String:(char*) sqlite3_column_text(get_city_statement, 2)]];
        
        [cityIDArrayTemp addObject:[NSString  stringWithUTF8String:(char*) sqlite3_column_text(get_city_statement, 1)]];
        
        [cityFatherArrayTemp addObject:[NSString  stringWithUTF8String:(char*) sqlite3_column_text(get_city_statement, 3)]];
    }
    sqlite3_reset(get_city_statement);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if(cityIDArrayTemp.count == 0)
    {
        [dic setObject:cityID forKey:@"ID"];
        [dic setObject:cityID forKey:@"Name"];
        [dic setObject:cityID forKey:@"Father"];
        return dic;
    }
    [dic setObject:[cityIDArrayTemp objectAtIndex:0] forKey:@"ID"];
    [dic setObject:[cityNameArrayTemp objectAtIndex:0] forKey:@"Name"];
    [dic setObject:[cityFatherArrayTemp objectAtIndex:0] forKey:@"Father"];
    
    return dic;
}

//根据区域ID 获取区域信息
- (NSDictionary *)getAreaInfo:(NSString *)areaID
{
    if (areaID == nil) {
        return nil;
    }
    const char *sql = [[NSString stringWithFormat:@"select * from area where areaID = %@",areaID] UTF8String];
    if (sqlite3_prepare_v2(database, sql, -1, &get_area_statement, NULL) != SQLITE_OK){
        Assert(0, "Error: failed to prepare area with message '%s'.", sqlite3_errmsg(database));
    }
    NSMutableArray *areaNameArrayTemp    = [[NSMutableArray alloc] init];
    NSMutableArray *areaIDArrayTemp      = [[NSMutableArray alloc] init];
    NSMutableArray *areaFatherArrayTemp  = [[NSMutableArray alloc] init];
    while(sqlite3_step(get_area_statement) == SQLITE_ROW){
        
        [areaNameArrayTemp addObject:[NSString  stringWithUTF8String:(char*) sqlite3_column_text(get_area_statement, 2)]];
        
        [areaIDArrayTemp addObject:[NSString  stringWithUTF8String:(char*) sqlite3_column_text(get_area_statement, 1)]];
        
        [areaFatherArrayTemp addObject:[NSString  stringWithUTF8String:(char*) sqlite3_column_text(get_area_statement, 3)]];
    }
    sqlite3_reset(get_area_statement);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if(areaIDArrayTemp.count == 0)
    {
        [dic setObject:areaID   forKey:@"ID"];
        [dic setObject:areaID     forKey:@"Name"];
        [dic setObject:areaID forKey:@"Father"];
        return dic;
    }
    [dic setObject:[areaIDArrayTemp objectAtIndex:0]   forKey:@"ID"];
    [dic setObject:[areaNameArrayTemp objectAtIndex:0]     forKey:@"Name"];
    [dic setObject:[areaFatherArrayTemp objectAtIndex:0] forKey:@"Father"];
    
    return dic;
}

//根据区域ID获取省名称
-(NSString *)getPName:(NSString *)areaID
{
    if(areaID == nil || [areaID isEqualToString:@""])
    {
        return @"未填写";
    }
    
    NSDictionary * areaInfo = [self getAreaInfo:areaID];
    NSDictionary * cityInfo = [self getCityInfo:[areaInfo objectForKey:@"Father"]];
    NSDictionary * provinceInfo = [self getProvinceInfo:[cityInfo objectForKey:@"Father"]];
    
    NSString * PString;

    PString = [NSString stringWithFormat:@"%@",[provinceInfo objectForKey:@"Name"]];
    
    return PString;
}

//根据区域ID获取省市名称
-(NSString *)getPCName:(NSString *)areaID;
{
    if(areaID == nil || [areaID isEqualToString:@""])
    {
        return @"未填写";
    }
        
    NSDictionary * areaInfo = [self getAreaInfo:areaID];
    NSDictionary * cityInfo = [self getCityInfo:[areaInfo objectForKey:@"Father"]];
    NSDictionary * provinceInfo = [self getProvinceInfo:[cityInfo objectForKey:@"Father"]];
    
    NSString * PCAString;
    if([[provinceInfo objectForKey:@"Name"] isEqualToString:[cityInfo objectForKey:@"Name"]])
    {   //省-市-区名称一样的处理方法
        PCAString = [NSString stringWithFormat:@"%@",[provinceInfo objectForKey:@"Name"]];
    }
    else
    {
        PCAString = [NSString stringWithFormat:@"%@%@",[provinceInfo objectForKey:@"Name"],[cityInfo objectForKey:@"Name"]];
        if (([[cityInfo objectForKey:@"Name"] isEqualToString:@"市辖区"]) || ([[cityInfo objectForKey:@"Name"] isEqualToString:@"县"]) || ([[cityInfo objectForKey:@"Name"] isEqualToString:@"市"]))
        {
            PCAString = [NSString stringWithFormat:@"%@",[provinceInfo objectForKey:@"Name"]];
        }
    }
    return PCAString;
}

//根据区域ID获取 省市区名称
//area  区域ID      provincesID(非必填-现居住地可用到)： 为兼容旧用户对provincesID进行处理，新用户舍弃
- (NSString *)getPCAName:(NSString *)areaID;
{
    if(areaID == nil || [areaID isEqualToString:@""])
    {
        return @"未填写";
    }
    
    NSDictionary * areaInfo = [self getAreaInfo:areaID];
    NSDictionary * cityInfo = [self getCityInfo:[areaInfo objectForKey:@"Father"]];
    NSDictionary * provinceInfo = [self getProvinceInfo:[cityInfo objectForKey:@"Father"]];
    
    NSString * PCAString;
    if([[provinceInfo objectForKey:@"Name"] isEqualToString:[cityInfo objectForKey:@"Name"]] && [[provinceInfo objectForKey:@"Name"] isEqualToString:[areaInfo objectForKey:@"Name"]])
    {   //省-市-区名称一样的处理方法
        PCAString = [NSString stringWithFormat:@"%@",[provinceInfo objectForKey:@"Name"]];
    }
    else
    {
        PCAString = [NSString stringWithFormat:@"%@%@%@",[provinceInfo objectForKey:@"Name"],[cityInfo objectForKey:@"Name"],[areaInfo objectForKey:@"Name"]];
    }
    return PCAString;
}

//根据区域ID获取 市ID
- (NSDictionary *)getCInfo:(NSString *)areaID
{
    if(areaID == nil || [areaID isEqualToString:@""])
    {
        return nil;
    }
    
    NSDictionary * areaInfo = [self getAreaInfo:areaID];
    NSDictionary * cityInfo = [self getCityInfo:[areaInfo objectForKey:@"Father"]];
    return cityInfo;
}

//根据市ID获取 市信息  如果市信息是市辖区 或者 县 取省信息
- (NSDictionary *)getCInfoWithCID:(NSString *)cityID
{
    if(cityID == nil || [cityID isEqualToString:@""])
    {
        return nil;
    }
    NSDictionary * cityInfo = [self getCityInfo:cityID];
    if (([[cityInfo objectForKey:@"Name"] isEqualToString:@"市辖区"]) || ([[cityInfo objectForKey:@"Name"] isEqualToString:@"县"]) || ([[cityInfo objectForKey:@"Name"] isEqualToString:@"市"]))
    {
        return [self getProvinceInfo:[cityInfo objectForKey:@"Father"]];
    }
    else
    {
        return cityInfo;
    }
}

//根据区域ID获取 省ID
- (NSDictionary *)getPInfo:(NSString *)areaID
{
    if(areaID == nil || [areaID isEqualToString:@""])
    {
        return nil;
    }
    
    NSDictionary * areaInfo = [self getAreaInfo:areaID];
    NSDictionary * cityInfo = [self getCityInfo:[areaInfo objectForKey:@"Father"]];
    NSDictionary * provinceInfo = [self getProvinceInfo:[cityInfo objectForKey:@"Father"]];
    return provinceInfo;
}

@end
