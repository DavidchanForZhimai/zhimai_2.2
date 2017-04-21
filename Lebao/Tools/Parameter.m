//
//  Parameter.m
//  Lebao
//
//  Created by David on 15/12/3.
//  Copyright © 2015年 David. All rights reserved.
//

#import "Parameter.h"
#import "CoreArchive.h"
@implementation Parameter
//必带参数
+ (NSMutableDictionary *)parameterWithSessicon
{
    NSMutableDictionary  *parameter = allocAndInit(NSMutableDictionary);
    if ([CoreArchive strForKey:KuserName]&&[CoreArchive strForKey:passWord]) {
        [parameter setObject:[CoreArchive strForKey:KuserName] forKey:KuserName];
        [parameter setObject:[CoreArchive strForKey:passWord] forKey:passWord];
        
    }
    [parameter setObject:@"20" forKey:@"t"];
    if ([CoreArchive strForKey:DeviceToken]) {
        [parameter setObject:[CoreArchive strForKey:DeviceToken] forKey:@"channelid"];
    }
    
    return parameter;
}
//判断是否有用户名和密码
+ (BOOL)isSession
{
    if ([CoreArchive strForKey:KuserName]&&[CoreArchive strForKey:passWord]) {
        
        return YES;
    }
    else
    {
        
        return NO;
    }
    
}

+ (NSString *)industryForChinese:(NSString *)industry
{
    NSString *str = @"其他";
    if ([industry isEqualToString:@"insurance"]) {
        str= @"保险";
    }
    if ([industry isEqualToString:@"finance"]) {
        str= @"金融";
    }
    if ([industry isEqualToString:@"property"]) {
        str= @"房产";
    }
    if ([industry isEqualToString:@"car"]) {
        str= @"车行";
    }
    
    return str;
}
+ (NSString *)industryForCode:(NSString *)industry
{
    NSString *str= @"other";
    if ([industry isEqualToString:@"保险"]) {
        
        str =@"insurance";
    }
    if ([industry isEqualToString:@"金融"]) {
        
        str =@"finance";
    }
    if ([industry isEqualToString:@"房产"]) {
        
        str =@"property";
    }
    if ([industry isEqualToString:@"车行"]) {
        str =@"car";
    }
    
    return str;
}

+ (IndustryCode)industryCode:(NSString *)industry
{
    int code = IndustryCodeother;
    if ([industry isEqualToString:@"保险"]) {
        code = IndustryCodeother;
    }
    if ([industry isEqualToString:@"经融"]) {
        code = IndustryCodeother;
    }
    if ([industry isEqualToString:@"房源"]) {
        code =IndustryCodeproperty;
    }
    if ([industry isEqualToString:@"车源"]) {
        code =IndustryCodecar;
    }
    
    return code;
}
+ (NSString *)industryChinese:(NSString *)industry
{
    NSString *str = @"产品";
    if ([industry isEqualToString:@"insurance"]) {
        str= @"产品";
    }
    if ([industry isEqualToString:@"finance"]) {
        str= @"产品";
    }
    if ([industry isEqualToString:@"property"]) {
        str= @"房源";
    }
    if ([industry isEqualToString:@"car"]) {
        str= @"车源";
    }
    
    return str;
    
}

//转换行业
+ (NSString *)zhuanghuanHangye:(NSString *)hangye formdata:(NSMutableArray *)industrys
{
    NSString *hangye_zw = @"";
    for (id Value in industrys) {
        if ([Value isKindOfClass:[NSDictionary class]]) {
            if ([hangye isEqualToString:Value[@"full_number"]] ) {
                hangye_zw =  Value[@"name"];
            }
        }
    }
    return  hangye_zw;
    
}

@end
