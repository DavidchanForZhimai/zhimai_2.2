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
    if ([CoreArchive strForKey:userName]&&[CoreArchive strForKey:passWord]) {
        [parameter setObject:[CoreArchive strForKey:userName] forKey:userName];
        [parameter setObject:[CoreArchive strForKey:passWord] forKey:passWord];
    }
    
    
    return parameter;
}
//判断是否有用户名和密码
+ (BOOL)isSession
{
    if ([CoreArchive strForKey:userName]&&[CoreArchive strForKey:passWord]) {
        
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
@end
