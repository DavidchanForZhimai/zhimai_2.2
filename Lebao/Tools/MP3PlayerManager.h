//
//  MP3PlayerManager.h
//  Lebao
//
//  Created by adnim on 16/7/19.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#define UploadAudioURL [NSString stringWithFormat:@"%@upload/audio",HttpURL]
typedef void (^PlayFinishBlock)(BOOL succeed);
typedef void (^FinishBlock)(BOOL succeed);
typedef void (^FinishuploadBlock)(BOOL succeed,id  audioDic);
typedef void (^FinishDownloadBlock)(BOOL succeed);
@interface MP3PlayerManager : NSObject<AVAudioRecorderDelegate,AVAudioPlayerDelegate>

@property (nonatomic,strong) AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//播放器
@property (nonatomic,copy) PlayFinishBlock playFinishBlock;//播放器播放成功后的回调
@property(nonatomic,copy) NSString *url;
- (BOOL)canRecord;
+ (MP3PlayerManager *)shareInstance;
//
- (void)audioRecorderWithURl:(NSString *)url;
- (void)stopAudioRecorder;
- (void)removeAudioRecorder;
- (void)stopPlayer;
-(void)pausePlayer;
-(void)playerNil;
- (void)audioPlayerWithURl:(NSString *)url;


//上传音频
- (void)uploadAudioWithType:(NSString *)type finishuploadBlock:(FinishuploadBlock)finishuploadBlock;
//下载音频
- (void)downLoadAudioWithUrl:(NSString *)url finishDownLoadBloak:(FinishDownloadBlock)finishDownLoadBloak;
@end
