//
//  CommunicationViewController.h
//  Lebao
//
//  Created by David on 15/12/28.
//  Copyright © 2015年 David. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,ChatTpye) {
    
     ChatRedEnvelopePTpye,
     ChatCustomerTpye,
     ChatMessageTpye
};
@interface CommunicationViewController : BaseViewController
@property (nonatomic,strong)NSString *receiver;
@property (nonatomic,strong)NSString *sourceid;
@property (nonatomic,strong) NSString *sourcetype;
@property (nonatomic,strong) NSString *senderid;
@property(nonatomic,assign)ChatTpye chatType;
@property(nonatomic,strong)NSDictionary *data;
@property(nonatomic,assign)BOOL isPopRoot;
@end
