//
//  Parameter.h
//  Lebao
//
//  Created by David on 15/12/3.
//  Copyright © 2015年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger) {
    IndustryCodeproperty,
    IndustryCodecar,
    IndustryCodeother
    
}IndustryCode;
@interface Parameter : NSObject
+ (NSMutableDictionary *)parameterWithSessicon;
//判断是否有用户名和密码
+ (BOOL)isSession;

//行业
+ (NSString *)industryForChinese:(NSString *)industry;
+ (NSString *)industryForCode:(NSString *)industry;

+ (IndustryCode)industryCode:(NSString *)industry;
+ (NSString *)industryChinese:(NSString *)industry;
@end
