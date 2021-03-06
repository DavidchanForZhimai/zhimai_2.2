//
//  MP3PlayerManager.m
//  Lebao
//
//  Created by adnim on 16/7/19.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MP3PlayerManager.h"
#import "lame.h"
#import "XLNetworkRequest.h"
static MP3PlayerManager* mP3PlayerManager;
@implementation MP3PlayerManager
+ (MP3PlayerManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        mP3PlayerManager = [[super alloc]init];
        
    });
    
    return mP3PlayerManager;
    
}

//录音
- (void)audioRecorderWithURl:(NSString *)url
{
    if (![self checkRecordPermission]) {
        return;
    }
    _url = url;
//    [self setAudioSession];
    [self setRecorder];
    [self.audioRecorder record];
    //首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
    
}
//停止录音
- (void)stopAudioRecorder
{
    
    [self.audioRecorder stop];
    
}
//删除录音
- (void)removeAudioRecorder
{
//    NSLog(@"removeAudioRecorder");
    [self.audioPlayer stop];
    [self.audioRecorder stop];
    [self.audioRecorder deleteRecording];
    
}

//播放
- (void)audioPlayerWithURl:(NSString *)url
{
         NSLog(@"file path:%@",url);
   
    _url = url;
    
    [self setPlayer];

    [self.audioPlayer play];
    
    
}
//停止播放
-(void)stopPlayer
{
    
    [self.audioPlayer stop];
    //删除近距离事件监听
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    _audioPlayer=nil;
    if (_playFinishBlock) {
        _playFinishBlock(YES);
    }
    
}
-(void)pausePlayer
{
    [self.audioPlayer pause];
}
-(void)playerNil
{
    self.audioPlayer=nil;
}
#pragma mark - 私有方法
/**
 *  设置音频会话
 */
//-(void)setAudioSession{
//    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
//    //设置为播放和录音状态，以便可以在录制完之后播放录音
//    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//    [audioSession setActive:YES error:nil];
//}

/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
-(NSURL *)getSavePath{
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:_url];
    //    NSLog(@"file path:%@",urlStr);
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
}
-(NSString *)getSavePathStr{
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:_url];
    //    NSLog(@"file path:%@",urlStr);
    return urlStr;
}

/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    
    //录音格式 无法使用
    [settings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    //采样率
    [settings setValue :[NSNumber numberWithFloat:8000] forKey: AVSampleRateKey];
    //通道数
    [settings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
    
    //音频质量,采样质量
    [settings setValue:[NSNumber numberWithInt:AVAudioQualityLow] forKey:AVEncoderAudioQualityKey];
    
    //....其他设置等
    return settings;
}

/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
-(void)setRecorder{
    
    _audioRecorder = nil;
    
    //创建录音文件保存路径
    NSURL *url=[self getSavePath];
    //创建录音格式设置
    NSDictionary *setting=[self getAudioSetting];
    //创建录音机
    NSError *error=nil;
    _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
    
    _audioRecorder.delegate=self;
    //        _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
    if (error) {
        NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
        
    }
    else
    {
        
    }
    
}

/**
 *  创建播放器
 *
 *  @return 播放器
 */
-(void)setPlayer{
    if (_audioPlayer==nil) {
        NSURL *url=[self getSavePath];
        NSError *error=nil;
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
//        [self setAudioWaiFangSession];
        self.audioPlayer.volume = 1.0f;
        _audioPlayer.numberOfLoops=0;
        [_audioPlayer prepareToPlay];
        _audioPlayer.delegate = self;
    }
    //添加近距离事件监听，添加前先设置为YES，如果设置完后还是NO的读话，说明当前设备没有近距离传感器
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:)name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
    
   
    
    
}
#pragma mark - 处理近距离监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)//黑屏
    {
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
    }
    else//没黑屏幕
    {
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        if (![self.audioPlayer isPlaying]) {//没有播放了，也没有在黑屏状态下，就可以把距离传感器关了
            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        }
    }
}
//扬声器模式
//-(void)setAudioWaiFangSession
//{
//    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
//    //设置为播放
//    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
//    [audioSession setActive:YES error:nil];
//}
#pragma mark - 录音机代理方法
/**
 *  录音完成，录音完成后播放录音
 *
 *  @param recorder 录音机对象
 *  @param flag     是否成功
 */
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    
//    NSLog(@"录音完成!");
}
#pragma mark - 播放器代理方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
//        NSLog(@"录音完成!");
    _audioPlayer=nil;
    //删除近距离事件监听
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];

    if (_playFinishBlock) {
        _playFinishBlock(YES);
    }
}

//新增api,获取录音权限. 返回值,YES为无拒绝,NO为拒绝录音.

- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                } else {
                    bCanRecord = NO;
                }
            }];
        }
    }
    
    return bCanRecord;
}

- (void)convertCafFilPath:(NSString *)cafFilePath mp3FilePath:(NSString *)mp3FilePath andfinishBlock:(FinishBlock)finishBlock
{
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 8000);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        //        NSLog(@"%@",[exception description]);
        [[ToolManager shareInstance] showAlertMessage:[exception description]];
    }
    @finally {
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
    }
    
    
    if (finishBlock) {
        finishBlock(YES);
    }

}
//转MP3
- (void)convertMp3FinishBlock:(FinishBlock)finishBlock
{
    
    NSString *cafFilePath = [self getSavePathStr];
    NSString *mp3FilePath = [self mp3Path];
    [self convertCafFilPath:cafFilePath mp3FilePath:mp3FilePath andfinishBlock:finishBlock];
    
}
- (NSString *)mp3Path
{
    NSString *mp3FileName = @"Mp3File";
    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    NSString *mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];
    
    return mp3FilePath;
}
//上传音频道服务器
- (void)uploadAudioWithType:(NSString *)type finishuploadBlock:(FinishuploadBlock)finishuploadBlock{
    
    [self convertMp3FinishBlock:^(BOOL succeed) {
        if (succeed) {
            
            XLFileConfig *fileConfig = allocAndInit(XLFileConfig);
            NSData *audioData =[NSData dataWithContentsOfFile:[self mp3Path]];
            fileConfig.fileData = audioData;
            fileConfig.name = @"audioFile";
            fileConfig.fileName =@"audio.mp3";
            fileConfig.mimeType =@"audio/mp3";
            NSMutableDictionary *parameter = [Parameter parameterWithSessicon];
            [parameter setObject:type forKey:Type];
            [parameter setObject:@"audioFile" forKey:@"name"];
            //            [[ToolManager shareInstance] showWithStatus:@"上传音频中..."];
            [XLNetworkRequest updateRequest:UploadAudioURL params:parameter fileConfig:fileConfig success:^(id responseObj) {
                
//                NSLog(@"responseObj =%@ parameter= %@",responseObj,parameter);
                
                if (responseObj) {
                    
                    if ([responseObj[@"rtcode"]intValue] ==1) {
                        [[ToolManager shareInstance] dismiss];
                        
                        finishuploadBlock(YES,responseObj);
                        
                    }
                    else
                    {
                        [[ToolManager shareInstance] showInfoWithStatus:responseObj[@"rtmsg"]];
                    }
                    
                }
                else
                {
                    [[ToolManager shareInstance] showInfoWithStatus];
                }
                
                
            } failure:^(NSError *error) {
                
                [[ToolManager shareInstance] showInfoWithStatus];
            }];
        }
        else
        {
            
            
            [[ToolManager shareInstance] showInfoWithStatus:@" 转化MP3格式错误"];
        }
    }];
    
    
}
- (void)uploadAudioWithType:(NSString *)type cafFilPath:(NSString *)cafFilePath mp3FilePath:(NSString *)mp3FilePath  finishuploadBlock:(FinishuploadBlock)finishuploadBlock
{
    [self convertCafFilPath:cafFilePath mp3FilePath:mp3FilePath andfinishBlock:^(BOOL succeed) {
        if (succeed) {
            
            [self uploadAudioWithType:type audioData:[NSData dataWithContentsOfFile:mp3FilePath] finishuploadBlock:finishuploadBlock];
        }
        else
        {
            
            
            [[ToolManager shareInstance] showInfoWithStatus:@" 转化MP3格式错误"];
        }
    }];

}
- (void)uploadAudioWithType:(NSString *)type  audioData:(NSData *)audioData finishuploadBlock:(FinishuploadBlock)finishuploadBlock
{
    
    
    XLFileConfig *fileConfig = allocAndInit(XLFileConfig);
    fileConfig.fileData = audioData;
    fileConfig.name = @"audioFile";
    fileConfig.fileName =@"audio.mp3";
    fileConfig.mimeType =@"audio/mp3";
    NSMutableDictionary *parameter = [Parameter parameterWithSessicon];
    [parameter setObject:type forKey:Type];
    [parameter setObject:@"audioFile" forKey:@"name"];
    //            [[ToolManager shareInstance] showWithStatus:@"上传音频中..."];
    [XLNetworkRequest updateRequest:UploadAudioURL params:parameter fileConfig:fileConfig success:^(id responseObj) {
        
        //                NSLog(@"responseObj =%@ parameter= %@",responseObj,parameter);
        
        if (responseObj) {
            
            if ([responseObj[@"rtcode"]intValue] ==1) {
                [[ToolManager shareInstance] dismiss];
                
                finishuploadBlock(YES,responseObj);
                
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus:responseObj[@"rtmsg"]];
            }
            
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus];
        }
        
        
    } failure:^(NSError *error) {
        
        [[ToolManager shareInstance] showInfoWithStatus];
    }];

}
//下载音频
- (void)downLoadAudioWithUrl:(NSString *)url  finishDownLoadBloak:(FinishDownloadBlock)finishDownLoadBloak{
    
    [XLNetworkRequest downloadRequest:url  successAndProgress:^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite){
        
        
    } complete:^(id dataObj, NSError *error) {
        
        if (!error) {
            finishDownLoadBloak(YES);
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus:@"播放失败!"];
            finishDownLoadBloak(NO);
        }
    }];
}
#pragma mark - 检查麦克风权限

- (BOOL)checkRecordPermission
{
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    
    if (avSession && [avSession respondsToSelector:@selector(requestRecordPermission:)]) {
        
        __block BOOL isPermission = NO;
        
        [avSession requestRecordPermission:^(BOOL granted) {
            
            if (!granted) {
                
                UIAlertView *alertV= [[UIAlertView alloc] initWithTitle:@"无法打开麦克风" message:@"请在“请在“设置-隐私-麦克风”选项中允许知脉访问您的麦克风" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"设置",nil];
                alertV.tag=333;
                [alertV show];
                return ;
            }
            
            isPermission = granted;
            
        }];
        
        return isPermission;
    }
    
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   if (alertView.tag ==333) {
        if (buttonIndex ==1) {
            NSURL *url = [NSURL URLWithString:@"prefs:root=Privacy&path=MICROPHONE"];
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
}
@end
