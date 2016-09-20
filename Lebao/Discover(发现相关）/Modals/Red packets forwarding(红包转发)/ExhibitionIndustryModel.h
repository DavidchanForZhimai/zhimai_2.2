//
//  ExhibitionIndustryModel.h
//  Lebao
//
//  Created by David on 15/12/3.
//  Copyright © 2015年 David. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ExhibitionIndustryUserinfo,ExhibitionIndustryRewarddatas,ExhibitionIndustryReadmost;
@interface ExhibitionIndustryModel : NSObject

@property (nonatomic, copy) NSString *readcount;

@property (nonatomic, strong) ExhibitionIndustryUserinfo *userinfo;

@property (nonatomic, copy) NSString *msgcount;

@property (nonatomic, strong) NSArray<ExhibitionIndustryRewarddatas *> *rewarddatas;

@property (nonatomic, copy) NSString *rtmsg;

@property (nonatomic, assign) NSInteger mostcount;

@property (nonatomic, copy) NSString *ranking;

@property (nonatomic, strong) NSArray<ExhibitionIndustryReadmost *> *readmost;

@property (nonatomic, copy) NSString *cluecount;

@property (nonatomic, copy) NSString *cooperationcount;

@property (nonatomic, assign) NSInteger mostpage;

@property (nonatomic, assign) NSInteger rewardpage;

@property (nonatomic, assign) NSInteger mostallpage;

@property (nonatomic, assign) NSInteger rewardcount;

@property (nonatomic, assign) NSInteger rtcode;

@property (nonatomic, assign) NSInteger rewardallpage;


@end


@interface ExhibitionIndustryUserinfo : NSObject

@property (nonatomic, copy) NSString *authen;

@property (nonatomic, copy) NSString *imgurl;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *realname;

@property (nonatomic, copy) NSString *industry;

@property (nonatomic, copy) NSString *abstract;

@property (nonatomic, copy) NSString *background;

@property (nonatomic, copy) NSString *sex;

@end

@interface ExhibitionIndustryRewarddatas : NSObject

@property (nonatomic, copy) NSString *imgurl;

@property (nonatomic, copy) NSString *reward;

@property (nonatomic, copy) NSString *comsum;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger rewardtime;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL istalk;

@property (nonatomic, copy) NSString *industry;

@property (nonatomic, assign) BOOL isspread;

@property (nonatomic, copy) NSString *actype;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *rewardforward;

@property (nonatomic, assign) BOOL isgetclue;

@property (nonatomic, assign) BOOL isreward;

@end

@interface ExhibitionIndustryReadmost : NSObject

@property (nonatomic, copy) NSString *readcover;

@property (nonatomic, copy) NSString *author;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger createdate;

@property (nonatomic, copy) NSString *imgurl;

@property (nonatomic, assign) BOOL isgetclue;

@end

