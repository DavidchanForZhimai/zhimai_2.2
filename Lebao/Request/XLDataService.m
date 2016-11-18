//
//  XLDataService.m
//  XLNetwork
//
//  Created by Shelin on 15/11/10.
//  Copyright © 2015年 GreatGate. All rights reserved.
//

#import "XLDataService.h"
#import "AFNetworking.h"
#import "BaseModal.h"
#import "ToolManager.h"
static id dataObj;
static XLDataService *xLDataService;
static UIAlertView *letout;
@interface XLDataService()<UIAlertViewDelegate>
@end
@implementation XLDataService


+ (void)getWithUrl:(NSString *)url param:(id)param modelClass:(Class)modelClass responseBlock:(responseBlock)responseDataBlock {
    [XLNetworkRequest getRequest:[self URLEncodedString:url] params:param success:^(id responseObj) {
        
        BaseModal *model = [BaseModal mj_objectWithKeyValues:responseObj];
        //登录退出
        if (model.rtcode ==2) {
            responseDataBlock(responseObj, nil);
            [[ToolManager shareInstance] dismiss];
            
            if (!letout) {
                if (!xLDataService) {
                    xLDataService = [[self alloc] init];
                }
                letout = [[UIAlertView alloc]initWithTitle:@"帐号异常" message:model.rtmsg delegate:xLDataService cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                
            }
            [letout show];
        }
        else
        {
            if (responseObj) {
                dataObj = [self modelTransformationWithResponseObj:responseObj modelClass:modelClass];
            }
            responseDataBlock(dataObj, nil);
        }
    } failure:^(NSError *error) {
        
        responseDataBlock(nil, error);
    }];
}

+ (void)postWithUrl:(NSString *)url param:(id)param modelClass:(Class)modelClass responseBlock:(responseBlock)responseDataBlock {
    
    [XLNetworkRequest postRequest:[self URLEncodedString:url] params:param success:^(id responseObj) {
        
        BaseModal *model = [BaseModal mj_objectWithKeyValues:responseObj];
        //登录退出
        if (model.rtcode ==2) {
            responseDataBlock(responseObj, nil);
            [[ToolManager shareInstance] dismiss];
            if (!letout) {
                if (!xLDataService) {
                    xLDataService = [[self alloc] init];
                }
                letout = [[UIAlertView alloc]initWithTitle:@"帐号异常" message:model.rtmsg delegate:xLDataService cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                
            }
            [letout show];
        }
        else
        {
            
            if (model.rtcode ==1) {
                
                dataObj = [self modelTransformationWithResponseObj:responseObj modelClass:modelClass];
                responseDataBlock(dataObj, nil);
            }
            else
            {
                 responseDataBlock(dataObj, nil);
               
            }
            
        }
    } failure:^(NSError *error) {
        
        responseDataBlock(dataObj, nil);
       
    }];
}

+ (void)putWithUrl:(NSString *)url param:(id)param modelClass:(Class)modelClass responseBlock:(responseBlock)responseDataBlock {
    
    [XLNetworkRequest putRequest:[self URLEncodedString:url] params:param success:^(id responseObj) {
        
        BaseModal *model = [BaseModal mj_objectWithKeyValues:responseObj];
        //登录退出
        if (model.rtcode ==2) {
            responseDataBlock(responseObj, nil);
            [[ToolManager shareInstance] dismiss];
            
            if (!letout) {
                if (!xLDataService) {
                    xLDataService = [[self alloc] init];
                }
                letout = [[UIAlertView alloc]initWithTitle:@"帐号异常" message:model.rtmsg delegate:xLDataService cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                
            }
            [letout show];
        }
        else
        {
            if (responseObj) {
                dataObj = [self modelTransformationWithResponseObj:responseObj modelClass:modelClass];
            }
            responseDataBlock(dataObj, nil);
        }
    } failure:^(NSError *error) {
        
        responseDataBlock(nil, error);
    }];
}

+ (void)deleteWithUrl:(NSString *)url param:(id)param modelClass:(Class)modelClass responseBlock:(responseBlock)responseDataBlock {
    
    [XLNetworkRequest deleteRequest:[self URLEncodedString:url] params:param success:^(id responseObj) {
        
        BaseModal *model = [BaseModal mj_objectWithKeyValues:responseObj];
        //登录退出
        if (model.rtcode ==2) {
            responseDataBlock(responseObj, nil);
            [[ToolManager shareInstance] dismiss];
            
            if (!letout) {
                if (!xLDataService) {
                    xLDataService = [[self alloc] init];
                }
                letout = [[UIAlertView alloc]initWithTitle:@"帐号异常" message:model.rtmsg delegate:xLDataService cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                
            }
            [letout show];
        }
        else
        {
            if (responseObj) {
                dataObj = [self modelTransformationWithResponseObj:responseObj modelClass:modelClass];
            }
            responseDataBlock(dataObj, nil);
        }
    } failure:^(NSError *error) {
        
        responseDataBlock(nil, error);
    }];
}
//拼装NSURL前，将NSString地址编码
+ (NSString *)URLEncodedString:(NSString*)resource {
//    CFStringRef url = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)resource, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8); // for some reason, releasing this is disasterous
    NSString *result = [resource stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    [result autorelease];
    
    return result;
}

/**
 数组、字典转化为模型
 */
+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass {
    
    
    return responseObj;
}

#pragma mark
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[ToolManager shareInstance] enterLoginView];
}
@end
