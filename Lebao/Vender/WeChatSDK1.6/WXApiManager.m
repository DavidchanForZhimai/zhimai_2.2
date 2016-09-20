//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"
//工具类
#import "ToolManager.h"
#define KWetChatPaySucceedNotification @"WetChatPaySucceedNotification"
@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

- (void)dealloc {
    self.delegate = nil;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
   
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)]) {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
            
            if (messageResp.errCode == WXSuccess) {
                [_delegate managerDidRecvMessageResponse:messageResp];
            }
            else
            {
                [self errorWetChatCodeShow:messageResp.errCode];
            }
            
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            
            if (authResp.errCode == WXSuccess) {
                 [_delegate managerDidRecvAuthResponse:authResp];
            }
            else
            {
              [self errorWetChatCodeShow:authResp.errCode];
            }

        }
    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAddCardResponse:)]) {
            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
            
            if (addCardResp.errCode == WXSuccess) {
                [_delegate managerDidRecvAddCardResponse:addCardResp];
            }
            else
            {
                [self errorWetChatCodeShow:addCardResp.errCode];
            }

        }
    }
    
    else if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg;
         PayResp *payResp = (PayResp *)resp;
        switch (payResp.errCode) {
            case WXSuccess:
                [_delegate managerDidPayResponse:payResp];
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", payResp.errCode,payResp.errStr];
                 [[ToolManager shareInstance] showErrorWithStatus:strMsg];
                break;
        }
       
       
    }

}
#pragma mark
#pragma mark 微信回调错误码
- (void)errorWetChatCodeShow:(int)errCode
{
    
    switch (errCode) {
        
        case WXErrCodeCommon:
            
            [[ToolManager  shareInstance] showErrorWithStatus:@"普通错误类型"];
            break;
        case WXErrCodeUserCancel:
            [[ToolManager  shareInstance] showErrorWithStatus:@"用户点击取消并返回"];
            break;
        case WXErrCodeSentFail:
            [[ToolManager  shareInstance] showErrorWithStatus:@"发送失败"];
            break;
        case WXErrCodeAuthDeny:
            [[ToolManager  shareInstance] showErrorWithStatus:@"授权失败"];
            break;
        case WXErrCodeUnsupport:
            [[ToolManager  shareInstance] showErrorWithStatus:@"微信不支持"];
            break;
            
        default:
            break;
    }
    
}
- (void)onReq:(BaseReq *)req {
  
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvGetMessageReq:)]) {
            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *)req;
            [_delegate managerDidRecvGetMessageReq:getMessageReq];
        }
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvShowMessageReq:)]) {
            ShowMessageFromWXReq *showMessageReq = (ShowMessageFromWXReq *)req;
            [_delegate managerDidRecvShowMessageReq:showMessageReq];
        }
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvLaunchFromWXReq:)]) {
            LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
            [_delegate managerDidRecvLaunchFromWXReq:launchReq];
        }
    }
}

@end
