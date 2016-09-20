//
//  WetChatShareManager.m
//  Lebao
//
//  Created by David on 16/3/18.
//  Copyright © 2016年 David. All rights reserved.
//

#import "WetChatShareManager.h"
//工具类
#import "ToolManager.h"
#import "UIImage+Extend.h"
#import "WXApi.h"//微信Api
#import "WXApiManager.h"//微信回调
#import "WetChatAuthenManager.h"//微信授权
#import "XLDataService.h"
#import "DWActionSheetView.h"
//红包文章/跨界传播 分享成功接口
//URL:appinterface/wxsuccess
#define Wxsuccess [NSString stringWithFormat:@"%@share/success",HttpURL]
@interface WetChatShareManager()<WXApiManagerDelegate>

@end
static WetChatShareManager *wetChatShareManager = nil;
static dispatch_once_t once;
@implementation WetChatShareManager
+ (instancetype)shareInstance
{
    if (!wetChatShareManager) {
        dispatch_once(&once, ^{
            
            wetChatShareManager = allocAndInit(WetChatShareManager);
            
        });
    }
    
    return wetChatShareManager;
    
}
#pragma mark
#pragma mark 分享图片
- (void)shareImageToWXApp:(UIImage *)image
{
    DWActionSheetView *_actionSheetView =[DWActionSheetView showShareViewWithTitle:@"分享" otherButtonTitles:@[@"weixing",@"weixingpenyouquan"] handler:^(DWActionSheetView *actionSheetView, NSInteger buttonIndex, NSString *shareText) {
        
        if (![WXApi isWXAppInstalled]) {
            
            [[ToolManager shareInstance] showInfoWithStatus:@"未安装微信"];
            return;
        }
        if (![WXApi isWXAppSupportApi]) {
            
            [[ToolManager shareInstance] showInfoWithStatus:@"此版本不支持微信分享"];
            return;
        }
        if (buttonIndex>=0) {
            
            
            WXMediaMessage *message = [WXMediaMessage message];
            message.description = @"知脉海报";
            //因为分享的图片有限制
            if (image) {
                
                float w = image.size.width;
                float h = image.size.height;
                if (w>120) {
                    w = 120;
                    h = 120.0/image.size.width*image.size.height;
                }
                UIImage *newImage = [image imageByScalingAndCroppingForSize:CGSizeMake(w, h)];
                [message setThumbImage:newImage];
            }
            else
            {
                [message setThumbImage:[UIImage imageNamed:@"wx-logo.jpg"]];
            }
            
            WXImageObject *imageObject=  [WXImageObject object];
            imageObject.imageData = UIImagePNGRepresentation(image);
            message.mediaObject = imageObject;
            
            SendMessageToWXReq *rep = [[SendMessageToWXReq alloc]init];
            rep.bText = NO;
            rep.message = message;
            switch (buttonIndex) {
                case 0:
                    message.title = @"知脉海报";
                    rep.scene = WXSceneSession;
                    break;
                case 1:
                    message.title = @"知脉海报" ;
                    rep.scene = WXSceneTimeline;
                    break;
                    
                default:
                    break;
            }
            [WXApi sendReq:rep];
            //回调
            [WXApiManager sharedManager].delegate =self;
        }
        else
        {
            return;
        }
    }];
    
    
    [_actionSheetView show];
}
#pragma mark
#pragma mark 动态分享
- (void)dynamicShareTo:(NSString *)title desc:(NSString *)desc image:(UIImage *)image shareurl:(NSString *)url
{
    if (![url hasPrefix:@"http://"]) {
        url = [NSString stringWithFormat:@"%@%@",HttpURL,url];
    }
    DWActionSheetView *_actionSheetView =[DWActionSheetView showShareViewWithTitle:@"分享" otherButtonTitles:@[@"weixing",@"weixingpenyouquan"] handler:^(DWActionSheetView *actionSheetView, NSInteger buttonIndex, NSString *shareText) {
        
        if (![WXApi isWXAppInstalled]) {
            
            [[ToolManager shareInstance] showInfoWithStatus:@"未安装微信"];
            return;
        }
        if (![WXApi isWXAppSupportApi]) {
            
            [[ToolManager shareInstance] showInfoWithStatus:@"此版本不支持微信分享"];
            return;
        }
        if (buttonIndex>=0) {
            
            
            WXMediaMessage *message = [WXMediaMessage message];
            message.description = desc;
            //因为分享的图片有限制
            if (image) {
                
                float w = image.size.width;
                float h = image.size.height;
                if (w>120) {
                    w = 120;
                    h = 120.0/image.size.width*image.size.height;
                }
                UIImage *newImage = [image imageByScalingAndCroppingForSize:CGSizeMake(w, h)];
                [message setThumbImage:newImage];
            }
            else
            {
                [message setThumbImage:[UIImage imageNamed:@"wx-logo.jpg"]];
            }
            
            WXWebpageObject *webpageObject=  [WXWebpageObject object];
            webpageObject.webpageUrl =url;
            message.mediaObject = webpageObject;
            
            SendMessageToWXReq *rep = [[SendMessageToWXReq alloc]init];
            rep.bText = NO;
            rep.message = message;
            switch (buttonIndex) {
                case 0:
                    message.title = title;
                    rep.scene = WXSceneSession;
                    break;
                case 1:
                    message.title = desc ;
                    rep.scene = WXSceneTimeline;
                    break;
                    
                default:
                    break;
            }
            [WXApi sendReq:rep];
            //回调
            [WXApiManager sharedManager].delegate =self;
        }
        else
        {
            return;
        }
    }];
    
    
    [_actionSheetView show];
    
}
#pragma mark
#pragma mark 本地分享
- (void)showLocalShareView:(NSArray *)arrays otherParamer:(NSArray *)Paramer title:(NSString *)title desc:(NSString *)desc  image:(UIImage *)image shareID:(NSString *)str isWxShareSucceedShouldNotice:(BOOL)isWxShareSucceedShouldNotice isAuthen:(BOOL)isAuthen
{
    __weak WetChatShareManager *weakSelf =self;
    DWOptionView *_actionSheetView =  [[DWOptionView alloc]initWithFrame:frame(0, 0, APPWIDTH, APPHEIGHT) options:arrays sureSeletedItemsBlock:^(NSArray *items) {
        NSMutableDictionary * parameter =[Parameter parameterWithSessicon];
        [parameter setObject:[NSString stringWithFormat:@"%@",items[0]] forKey:@"isaddress"];
        [parameter setObject:[NSString stringWithFormat:@"%@",items[1]] forKey:@"isranking"];
        [parameter setObject:[NSString stringWithFormat:@"%@",items[2]] forKey:@"isauthor"];
        for (NSDictionary *dic in Paramer) {
            [parameter setObject:dic[@"value"] forKey:dic[@"key"]];
            
        }
        [weakSelf shareToWeixinApp:title desc:desc image:image shareID:str isWxShareSucceedShouldNotice:isWxShareSucceedShouldNotice isLocalShare:YES localshareParme:parameter isAuthen:isAuthen];
        
    }];
    _actionSheetView.tag =0;
}
#pragma mark
#pragma mark 分享到微信
- (void)shareToWeixinApp:(NSString *)title desc:(NSString *)desc  image:(UIImage *)image shareID:(NSString *)str isWxShareSucceedShouldNotice:(BOOL)isWxShareSucceedShouldNotice isLocalShare:(BOOL)isLocalShare localshareParme:(NSMutableDictionary *)shareparme isAuthen:(BOOL)isAuthen
{
    _isWxShareSucceedShouldNotice = isWxShareSucceedShouldNotice;
    DWActionSheetView *_actionSheetView =[DWActionSheetView showShareViewWithTitle:@"分享" otherButtonTitles:@[@"weixing",@"weixingpenyouquan"] handler:^(DWActionSheetView *actionSheetView, NSInteger buttonIndex, NSString *shareText) {
        
        if (![WXApi isWXAppInstalled]) {
            
            [[ToolManager shareInstance] showInfoWithStatus:@"未安装微信"];
            return;
        }
        if (![WXApi isWXAppSupportApi]) {
            
            [[ToolManager shareInstance] showInfoWithStatus:@"此版本不支持微信分享"];
            return;
        }
        if (buttonIndex>=0) {
            
            [WetChatAuthenManager shareInstance].shareID =str;
            
            [[WetChatAuthenManager shareInstance] wetChatAuthen:isLocalShare isAuthen:isAuthen localshareParme:shareparme succeedBlock:^(NSString *url, NSString *openid, NSString *uid, NSString *ID,NSString *unionid) {
                if (openid) {
                    _openId = openid;
                    _uid = uid;
                    _Id = ID;
                    _unionid = unionid;
                }
                
                if (url) {
                    
                    if (![url hasPrefix:@"http://"]) {
                        url =[ NSString stringWithFormat:@"%@%@",HttpURL,url];
                    }
                    WXMediaMessage *message = [WXMediaMessage message];
                    message.title = title;
                    message.description = desc;
                    //因为分享的图片有限制
                    if (image) {
                        
                        float w = image.size.width;
                        float h = image.size.height;
                        if (w>120) {
                            w = 120;
                            h = 120.0/image.size.width*image.size.height;
                        }
                        UIImage *newImage = [image imageByScalingAndCroppingForSize:CGSizeMake(w, h)];
                        [message setThumbImage:newImage];
                    }
                    else
                    {
                        [message setThumbImage:[UIImage imageNamed:@"wx-logo.jpg"]];
                    }
                    
                    WXWebpageObject *webpageObject=  [WXWebpageObject object];
                    webpageObject.webpageUrl =url;
                    message.mediaObject = webpageObject;
                    
                    SendMessageToWXReq *rep = [[SendMessageToWXReq alloc]init];
                    rep.bText = NO;
                    rep.message = message;
                    switch (buttonIndex) {
                        case 0:
                            rep.scene = WXSceneSession;
                            break;
                        case 1:
                            rep.scene = WXSceneTimeline;
                            break;
                            
                        default:
                            break;
                    }
                    [WXApi sendReq:rep];
                    //回调
                    [WXApiManager sharedManager].delegate =self;
                }
            }];
            
            
            
        }
        else
        {
            return;
        }
        
        
    }];
    [_actionSheetView show];
}
- (void)shareToWeixinApp:(NSString *)title desc:(NSString *)desc  image:(UIImage *)image shareID:(NSString *)str isWxShareSucceedShouldNotice:(BOOL)isWxShareSucceedShouldNotice isAuthen:(BOOL)isAuthen
{
    [self shareToWeixinApp:title desc:desc image:image shareID:str isWxShareSucceedShouldNotice:isWxShareSucceedShouldNotice isLocalShare:NO localshareParme:nil isAuthen:isAuthen];
}
#pragma mark
#pragma mark - 微信回调
- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[ToolManager shareInstance] showSuccessWithStatus:@"分享成功"];
        if (_isWxShareSucceedShouldNotice) {
            NSMutableDictionary *param = [Parameter parameterWithSessicon];
            [param setObject:_openId forKey:@"openid"];
            [param setObject:_Id forKey:@"acid"];
            [param setObject:_uid forKey:@"uid"];
            [param setObject:_unionid forKey:@"unionid"];
            //            NSLog(@"param =%@",param);
            [XLDataService postWithUrl:Wxsuccess param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
                
                //
            }];
        }
        
    });
}


@end
