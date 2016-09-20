//
//  PublishDynamicVC.m
//  Lebao
//
//  Created by adnim on 16/8/1.
//  Copyright © 2016年 David. All rights reserved.
//

#import "PublishDynamicVC.h"
#import "QTRejectViewCell.h"
#import "TZImagePickerController.h"
#import "UpLoadImageManager.h"
#import "XWDragCellCollectionView.h"
#import "HomeInfo.h"
#import "MJExtension.h"
#import "XLDataService.h"
#import "Parameter.h"
#import "LWImageBrowser.h"
#define PADDING 10
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define X(v)               (v).frame.origin.x
#define Y(v)               (v).frame.origin.y
#define WIDTH(v)           (v).frame.size.width
#define HEIGHT(v)          (v).frame.size.height

#define MinX(v)            CGRectGetMinX((v).frame) // 获得控件屏幕的x坐标
#define MinY(v)            CGRectGetMinY((v).frame) // 获得控件屏幕的Y坐标

#define MidX(v)            CGRectGetMidX((v).frame) //横坐标加上到控件中点坐标
#define MidY(v)            CGRectGetMidY((v).frame) //纵坐标加上到控件中点坐标

#define MaxX(v)            CGRectGetMaxX((v).frame) //横坐标加上控件的宽度
#define MaxY(v)            CGRectGetMaxY((v).frame) //纵坐标加上控件的高度


@interface PublishDynamicVC ()<UITextViewDelegate,UITextFieldDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,XWDragCellCollectionViewDataSource, XWDragCellCollectionViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,UIActionSheetDelegate>
{
    
    XWDragCellCollectionView *_collectionView;
    NSInteger Pnumb;
    NSMutableArray *upLoadphotos;
    
    UIActionSheet *actionSheetTopic;
    NSMutableArray *objTopic;
    
}


@end

@implementation PublishDynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=BACKCOLOR;
    
    Pnumb=9;
    [self createUI];
    [self addImg];
    
    
    
}

-(void)postDataSouce
{
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
    [param setValue:@(1) forKey:@"page"];
    [[ToolManager shareInstance] showWithStatus];
    [XLDataService postWithUrl:[NSString stringWithFormat:@"%@dynamic/topic",HttpURL] param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        actionSheetTopic=[[UIActionSheet alloc]initWithTitle:@"请选择您想要发送的话题" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheetTopic.delegate=self;
        actionSheetTopic.tag=1002;
        objTopic=[[NSMutableArray alloc]init];
        if (dataObj) {
            if ([dataObj[@"rtcode"] intValue]==1) {
                [[ToolManager shareInstance]dismiss];
                
                for (id obj in dataObj[@"datas"]) {
                    [objTopic addObject:obj[@"tipic"]];
                }
                //                NSLog(@"dataObj =%@",objTopic);
                
                if (objTopic.count!=0) {
                    for (id obj in objTopic) {
                        [actionSheetTopic addButtonWithTitle:obj];
                    }
                }else{
                    [objTopic addObject:@"#知脉有我更精彩#"];
                    
                }
                
                [actionSheetTopic showInView:self.view];
            }
            else
            {
                [[ToolManager shareInstance]dismiss];
                [objTopic addObject:@"#知脉有我更精彩#"];
                //                [[ToolManager shareInstance] showInfoWithStatus:dataObj[@"rtmsg"]];
                [actionSheetTopic showInView:self.view];
            }
        }
        else
        {
            [[ToolManager shareInstance]dismiss];
            //            [[ToolManager shareInstance] showInfoWithStatus];
            [objTopic addObject:@"#知脉有我更精彩#"];
            [actionSheetTopic addButtonWithTitle:@"#知脉有我更精彩#"];
            [actionSheetTopic showInView:self.view];
        }
    }];
}

-(void)createUI{
    UIView * navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 60, 44);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    backBtn.imageView.contentMode = UIViewContentModeLeft;
    [backBtn setImage:[UIImage imageNamed:@"iconfont-fanhui"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    UILabel * titLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 20, 120, 44)];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.textColor = [UIColor blackColor];
    titLab.text = @"发布动态";
    titLab.font = [UIFont systemFontOfSize:16];
    [navView addSubview:titLab];
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0.5)];
    hxV.backgroundColor = [UIColor colorWithRed:0.816 green:0.820 blue:0.827 alpha:1.000];
    [self.view addSubview:hxV];
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(navView.size.width-50, 20, 60, 44);
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    rightBtn.imageView.contentMode = UIViewContentModeLeft;
    [rightBtn setImage:[UIImage imageNamed:@"wancheng"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:rightBtn];
    
}

#pragma mark 添加照片的相关
-(void)addImg{
    self.phonelist = [[NSMutableArray alloc]init];
    self.svMain = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 65, APPWIDTH, APPHEIGHT-65)];
    self.svMain.backgroundColor = [UIColor clearColor];
    self.svMain.showsVerticalScrollIndicator = NO;
    self.svMain.showsHorizontalScrollIndicator = NO;
    self.svMain.delegate = self;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(huishouAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.svMain addGestureRecognizer:tap];
    [self.view addSubview:self.svMain];
    
    self.viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, 10, APPWIDTH, 130)];
    self.viewBg.backgroundColor = [UIColor whiteColor];
    [self.svMain addSubview:self.viewBg];
    
    self.tfView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 130)];
    self.tfView.font = [UIFont systemFontOfSize:13];
    self.tfView.text = @"请输入您想要分享的新鲜事(最多255个字)";
    self.tfView.textColor = [UIColor colorWithRed:0.741 green:0.741 blue:0.745 alpha:1.000];
    self.tfView.returnKeyType = UIReturnKeySend;
    self.tfView.delegate = self;
    
    [self.viewBg addSubview:self.tfView];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[XWDragCellCollectionView alloc]initWithFrame:CGRectMake(0, MaxY(self.viewBg), WIDTH(self.view),(APPWIDTH-40)/3+20) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[QTRejectViewCell class] forCellWithReuseIdentifier:@"rejectViewMeCell"];
    [self.svMain addSubview:_collectionView];
    
    self.viewlin = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT(_collectionView)-1, APPWIDTH, 1)];
    self.viewlin.backgroundColor = UIColorFromRGB(0xe6e6e6);
    [_collectionView addSubview:self.viewlin];
    
    //添加照片按钮
    self.btnAddPhone = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnAddPhone.frame = CGRectMake(10, 10, (APPWIDTH-40)/3, (APPWIDTH-40)/3);
    self.btnAddPhone.layer.borderWidth=1;
    self.btnAddPhone.layer.borderColor=[UIColor colorWithWhite:0.875 alpha:1.000].CGColor;
    self.btnAddPhone.layer.cornerRadius=5;
    
    [self.btnAddPhone setImage:[UIImage imageNamed:@"icon_find_phone_tianjia2"] forState:UIControlStateNormal];
    [self.btnAddPhone addTarget:self action:@selector(BtnAddPhoneClick) forControlEvents:UIControlEventTouchUpInside];
    [_collectionView addSubview:self.btnAddPhone];
    
    //添加话题按钮
    UIImage *image = [UIImage imageNamed:@"2huati"];
    float btnAddPhoneW = (APPWIDTH-40)/3;
    float titleSize = 32*SpacedFonts;
    float juli = 4;
    self.hotTopicBtn=[[BaseButton alloc]initWithFrame:CGRectMake(20+btnAddPhoneW, 10, btnAddPhoneW, btnAddPhoneW) setTitle:@"话题" titleSize:titleSize titleColor:[UIColor colorWithRed:0.745 green:0.749 blue:0.757 alpha:1.000] backgroundImage:nil iconImage:image highlightImage:image setTitleOrgin:CGPointMake((btnAddPhoneW - image.size.height - titleSize -juli)/2 + image.size.height + juli, (btnAddPhoneW - 2*titleSize)/2- image.size.width ) setImageOrgin:CGPointMake((btnAddPhoneW - image.size.height - titleSize-juli)/2, (btnAddPhoneW - image.size.width)/2) inView:_collectionView];
    __weak typeof(self) weakSelf = self;
    self.hotTopicBtn.didClickBtnBlock = ^
    {
        [weakSelf BtnhotTopicBtnClick];
    };
    
    self.hotTopicBtn.layer.borderWidth=1;
    self.hotTopicBtn.layer.borderColor=[UIColor colorWithWhite:0.875 alpha:1.000].CGColor;
    self.hotTopicBtn.layer.cornerRadius=5;
    //滚动视图
    self.svMain.contentSize = CGSizeMake(APPWIDTH,MaxY(_collectionView));
    
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction
{
    if ([self.tfView.text isEqualToString:@"请输入您想要分享的新鲜事(最多255个字)"]||self.tfView.text.length <1) {
        HUDText(@"请输入您想要分享的新鲜事(最多255个字)");
        return;
    }else {
        
        //上传图片
        [[ToolManager shareInstance] showWithStatus:@"疯狂上传中..."];
        //        NSLog(@"self.phonelist =%@",self.phonelist);
        if (self.phonelist.count ==0) {
            [[HomeInfo shareInstance] adddynamic:self.tfView.text imgs:nil andcallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonDic) {
                //                NSLog(@"%@",jsonDic);
                if (issucced) {
                    if (_faBuSucceedBlock) {
                        _faBuSucceedBlock();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                    [[ToolManager shareInstance] dismiss];
                }
                else
                {
                    [[ToolManager shareInstance] showInfoWithStatus:info];
                }
            }];
        }
        else
        {
            
            upLoadphotos = [[NSMutableArray alloc]init];
            for (UIImage *image in self.phonelist) {
                
                [[UpLoadImageManager shareInstance] upLoadImageType:@"property" image:image imageBlock:^(UpLoadImageModal *upLoadImageModal) {
                    
                    NSArray *images = [NSArray arrayWithObjects:upLoadImageModal.imgurl,upLoadImageModal.abbr_imgurl, nil];
                    [upLoadphotos addObject:images];
                    
                    if (upLoadphotos.count==self.phonelist.count) {
                        [[HomeInfo shareInstance] adddynamic:self.tfView.text imgs:[upLoadphotos mj_JSONString] andcallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonDic) {
                            
                            if (issucced) {
                                [self.navigationController popViewControllerAnimated:YES];
                                if (_faBuSucceedBlock) {
                                    _faBuSucceedBlock();
                                }
                                [[ToolManager shareInstance] dismiss];
                            }
                            else
                            {
                                [[ToolManager shareInstance] showInfoWithStatus:info];
                            }
                        }];
                    }
                }];
            }
        }
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length <1) {
        textView.text = @"请输入您想要分享的新鲜事(最多255个字)";
        textView.textColor = [UIColor colorWithRed:0.741 green:0.741 blue:0.745 alpha:1.000];
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString: @"请输入您想要分享的新鲜事(最多255个字)"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
}


//限制字数
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([string length]==255)
    {
        return NO;
    }
    else if ([string length] >255)
    {
        NSLog(@"string length%ld",[string length]);
        string = [string substringToIndex:255];
        textView.text = string;
        
        return NO;
    }
    else
        return YES;
}
-(void)huishouAction
{
    [self.view endEditing:YES];
}
#pragma mark -图片方法
//颜色生成图片方法
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
#pragma mark - UICollectionViewDataSource

- (NSArray *)dataSourceArrayOfCollectionView:(XWDragCellCollectionView *)collectionView{
    return self.phonelist;
}

- (void)dragCellCollectionView:(XWDragCellCollectionView *)collectionView newDataArrayAfterMove:(NSMutableArray *)newDataArray{
    [self.phonelist removeAllObjects];
    [self.phonelist addObjectsFromArray:newDataArray];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.phonelist.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QTRejectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rejectViewMeCell" forIndexPath:indexPath];
    
    cell.imageView.image = [self.phonelist objectAtIndex:indexPath.row];
    UITapGestureRecognizer *oneGR=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onetap:)];
    [cell.imageView addGestureRecognizer:oneGR];
    
    cell.delBtn.tag = 100+indexPath.row;
    [cell.delBtn addTarget:self action:@selector(BtnDelPhone:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)onetap:(UITapGestureRecognizer *)sender{
    
    int tag =0;
    NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i=0;i<self.phonelist.count;i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        QTRejectViewCell *cell = (QTRejectViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        if ([cell.imageView isEqual:sender.view]) {
            tag =i;
        }
        LWImageBrowserModel* imageModel = [[LWImageBrowserModel alloc] initWithLocalImage:cell.imageView.image imageViewSuperView:cell positionAtSuperView:cell.imageView.frame index:i];
        [tmp addObject:imageModel];
    }
    
    LWImageBrowser* imageBrowser = [[LWImageBrowser alloc] initWithParentViewController:self
                                                                            imageModels:tmp
                                                                           currentIndex:tag];
    imageBrowser.view.backgroundColor = [UIColor blackColor];
    [imageBrowser show];
    
}
#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth-40)/3, (kScreenWidth-40)/3);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(PADDING, PADDING, PADDING, PADDING);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDLog(@"indexPath==%@被点击了",indexPath);
}
//删除照片的事件
- (void)BtnDelPhone:(UIButton *)sender{
    [self.view endEditing:YES];
    [self.phonelist removeObjectAtIndex:sender.tag-100];
    Pnumb++;
    [self resetLayout];
    
}
//添加图片事件
- (void)BtnAddPhoneClick{
    [self.view endEditing:YES];
    if (Pnumb==0) {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您已选择满9张图片,可删除后替换" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    UIActionSheet *actionSheet=[[UIActionSheet alloc]init];
    [actionSheet addButtonWithTitle:@"拍照"];
    [actionSheet addButtonWithTitle:@"从手机选择"];
    [actionSheet addButtonWithTitle:@"取消"];
    
    actionSheet.delegate=self;
    actionSheet.tag=1001;
    [actionSheet showInView:self.view];
    
}
//删除照片
- (void)DelClick{
    [self.phonelist removeAllObjects];
    [self resetLayout];
}
-(void)resetLayout{
    int columnCount = ceilf((_phonelist.count + 2) * 1.0 / 3);
    float height = columnCount * ((kScreenWidth-40)/3 +10)+10;
    if (height < (kScreenWidth-40)/3+20) {
        height = (kScreenWidth-40)/3+20;
    }
    CGRect rect = _collectionView.frame;
    rect.size.height = height;
    _collectionView.frame = rect;
    [_collectionView reloadData];
    
    self.btnAddPhone.frame = CGRectMake(10+(10+(kScreenWidth-40)/3)*(self.phonelist.count%3),10+(10+(kScreenWidth-40)/3)*(self.phonelist.count/3),(kScreenWidth-40)/3,(kScreenWidth-40)/3);
    
    self.hotTopicBtn.frame = CGRectMake(10+(10+(kScreenWidth-40)/3)*((self.phonelist.count+1)%3), HEIGHT(_collectionView)-(kScreenWidth-40)/3-10,(kScreenWidth-40)/3,(kScreenWidth-40)/3);
    
    self.viewlin.frame = CGRectMake(0, HEIGHT(_collectionView)-1, kScreenWidth, 1);
    self.svMain.contentSize = CGSizeMake(kScreenWidth,MaxY(_collectionView));
    
}

#pragma mark - 话题按钮
-(void)BtnhotTopicBtnClick
{
    [self postDataSouce];
    [self.view endEditing:YES];
}
#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag==1001) {
        if (buttonIndex==0) {
            
            [self callCameraOrPhotoWithType:UIImagePickerControllerSourceTypeCamera];
            
            
        }else if (buttonIndex==1) {
            
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:Pnumb delegate:nil];
            // 你可以通过block或者代理，来得到用户选择的照片.
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
                [self.phonelist addObjectsFromArray:photos];
                Pnumb-=photos.count;    
                [self resetLayout];
            }];
            // 在这里设置imagePickerVc的外观
            imagePickerVc.navigationBar.barTintColor = [UIColor blackColor];
            imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
            // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
            // 设置是否可以选择视频/原图
            imagePickerVc.allowPickingVideo = NO;
            // imagePickerVc.allowPickingOriginalPhoto = NO;
            imagePickerVc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:imagePickerVc animated:YES completion:nil];
            
        }else if (buttonIndex==2) {
        }
        
    }
    else if (actionSheet.tag==1002) {
        if (buttonIndex!=0) {
            if (objTopic.count!=0) {
                if ([_tfView.text isEqualToString: @"请输入您想要分享的新鲜事(最多255个字)"]) {
                    _tfView.text =objTopic[buttonIndex-1];
                    _tfView.textColor=[UIColor blackColor];
                }else {
                    _tfView.text =[NSString stringWithFormat:@"%@%@",_tfView.text,objTopic[buttonIndex-1]];
                    _tfView.textColor=[UIColor blackColor];
                }
            }
            
        }else if(buttonIndex==0){}
        
    }
    
}

-(void)callCameraOrPhotoWithType:(UIImagePickerControllerSourceType)sourceType{
    BOOL isCamera = YES;
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {//判断是否有相机
        isCamera = [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera];
        
    }
    if (isCamera) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;//为NO，则不会出现系统的编辑界面
        imagePicker.sourceType = sourceType;
        
        [self presentViewController:imagePicker animated:YES completion:^(){
            if ([[[UIDevice currentDevice] systemVersion]floatValue]>=7.0) {
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                
            }
            else{
                
            }
            
        }];
    } else {
        
    }
}
#pragma UIImagePickerControllerDelegate
//相册或则相机选择上传的实现
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)aImage editingInfo:(NSDictionary *)editingInfo{
    
    NSArray *photos = [[NSArray alloc]initWithObjects:aImage, nil];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        // [self uploadPhotos:photos];
        [self.phonelist addObjectsFromArray:photos];
        Pnumb--;
        [self resetLayout];
        
    }];
}
#pragma UICollectionViewCellDelegate

//collectionView可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.tfView resignFirstResponder];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([@"\n" isEqualToString:string] == YES){
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
