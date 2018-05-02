//
//  BATKangDoctorViewController.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 2017/1/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrKangViewController.h"

#import "BATDrKangInputBar.h"

#import "BATDrKangBottomCollectionViewCell.h"
#import "BATDrKangDiseaseView.h"
#import "BATDrKangDetailView.h"

#import "BATLoginModel.h"
#import "BATDrKangModel.h"
#import "BATPerson.h"
#import "BATDrKangIntroductionModel.h"

#import "BATRegisterHospitalListViewController.h"
#import "BATRegisterDepartmentListViewController.h"
#import "BATKangDoctorHospitalListViewController.h"
#import "BATDrKangHistoryViewController.h"
//#import "BATHealthThreeSecondsController.h"  //健康3秒钟
//#import "BATHealthyInfoViewController.h"  //健康3秒钟健康资料

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AVFoundation/AVFoundation.h>

#import "BATJSObject.h"
#import "iflyMSC/IFlyMSC.h"
#import "ISRDataHelper.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件


static  NSString * const BOTTOM_CELL = @"BottomCollectionViewCell";

#define HistoryPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HistoryPath.sqlite"]

@interface BATDrKangViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,AVAudioPlayerDelegate,YYTextViewDelegate,IFlySpeechRecognizerDelegate,IFlySpeechSynthesizerDelegate,BMKGeoCodeSearchDelegate,UIWebViewDelegate>

//JS
@property (nonatomic,strong) JSContext *context;
@property (nonatomic,copy) NSString *webFilePath;
//UI
@property (nonatomic,strong) UIWebView *chatWebView;
@property (nonatomic,strong) NSArray *bottomKeyArray;
@property (nonatomic,strong) UICollectionView *bottomCollectionView;
//@property (nonatomic,strong) NSIndexPath *lastIndexPath;

@property (nonatomic,strong) BATDrKangInputBar *inputBar;

@property (nonatomic,strong) BATDrKangDetailView *detailView;
@property (nonatomic,strong) BATDrKangDiseaseView *diseaseView;


//音乐播放
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;

//语音识别
@property (nonatomic,strong) UIImageView *voiceAlertView;
@property (nonatomic,strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象
@property (nonatomic,copy) NSString *result;

//语音合成
@property (nonatomic,strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

//地理坐标
@property (nonatomic,assign) BOOL isFirstLocationFail;
@property (nonatomic,assign) BOOL isGetLocation;
@property (nonatomic,assign) CLLocationCoordinate2D currentLocation;
@property (nonatomic,assign) double hospitalLatitude;
@property (nonatomic,assign) double hospitalLongitude;

//最大数
@property (nonatomic,assign) int maxWordNumber;


@end

@implementation BATDrKangViewController
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"康博士";
    self.result = @"";
    self.isFirstLocationFail = YES;
    
    
//    _bottomKeyArray = @[@"智能问诊",@"常见疾病",@"历史评估",@"健康3秒钟"];
    _bottomKeyArray = @[@"智能问诊",@"常见疾病",@"历史评估"];

    self.maxWordNumber = 100;
    
    //服务器
    //    [self.chatWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/WebApp/kdoctor/MsgBox",APP_H5_DOMAIN_URL]]]];
    
    //加载本地html文件
    NSString *resPath = [[NSBundle mainBundle] resourcePath];
    self.webFilePath = [resPath stringByAppendingPathComponent:@"msgBoxIndex.html"];
    [self.chatWebView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initFileURLWithPath:self.webFilePath]]];
    
    
    
    [self layoutPages];
    
    
    //keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //定位成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLocationInfo:) name:@"LOCATION_INFO" object:nil];
    //定位失败，用深圳作为默认地址
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLocationFailure) name:@"LOCATION_FAILURE" object:nil];
    
    //评价通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(evaluationSendMessage:) name:@"DrKangEvaluationResultNotification" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //    [self.chatTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BEGIN_GET_LOCATION" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.iFlySpeechSynthesizer stopSpeaking];
    [self.iFlySpeechRecognizer stopListening];
    
}

#pragma mark - UIWebViewDelegate
- (void)sendMsg:(NSString *)content {
    
    NSString *avatarUrl = @"";
    if (LOGIN_STATION) {
        BATPerson *person = PERSON_INFO;
        avatarUrl = person.Data.PhotoPath;
    }
    if (avatarUrl == nil) {
        avatarUrl = @"";
    }
    NSDictionary *dic = @{@"content":content,@"icon":avatarUrl};
    
    NSString *jsonStr = [Tools dataTojsonString:dic];
    
    [self.chatWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"sendMsg(%@)",jsonStr]];
    
}

- (void)receiveMsg:(NSString *)content {
    
    if ([content containsString:@"</a>"]) {
        [self.inputBar.textView resignFirstResponder];
    }
    
    NSString *avatarUrl = @"";
    //默认为蓝色头像
    avatarUrl = @"http://upload.jkbat.com/Files/20171127/2yc14es3.jxy.png";
    if (LOGIN_STATION) {
        BATPerson *person = PERSON_INFO;
        if ([person.Data.Sex isEqualToString:@"0"]) { //女
            avatarUrl = @"http://upload.jkbat.com/Files/20171127/2yc14es3.jxy.png";
        }
    }
    
    if (avatarUrl == nil) {
        avatarUrl = @"";
    }
    
    NSDictionary *dic = @{@"content":content,@"icon":avatarUrl};
    
    NSString *jsonStr = [Tools dataTojsonString:dic];
    
    [self.chatWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"receiveMsg(%@)",jsonStr]];
    
}

- (void)receiveMusic:(NSString *)index {
    
    NSDictionary *dic = @{@"content":@"243",@"msgType":@5,@"value":index};
    
    NSString *jsonStr = [Tools dataTojsonString:dic];
    
    [self.chatWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"receiveMsg(%@)",jsonStr]];
}

- (void)scrollToBottom {
    
    NSDictionary *dic = @{};
    
    NSString *jsonStr = [Tools dataTojsonString:dic];
    
    [self.chatWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"scrollToBottom(%@)",jsonStr]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    
    //    if ([request.URL.absoluteString isEqualToString:[NSString stringWithFormat:@"%@/WebApp/kdoctor/MsgBox",APP_H5_DOMAIN_URL]]) {
    //
    //        return YES;
    //    }
    
    if ([request.URL.absoluteString isEqualToString:[[NSURL alloc] initFileURLWithPath:self.webFilePath].absoluteString]) {
        
        return YES;
    }
    
    NSURL *URL = request.URL;
    DDLogDebug(@"%@",URL);
    NSString *tmpUrl = URL.absoluteString;
    NSDictionary *urlPara = [Tools getParametersWithUrlString:tmpUrl];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:urlPara];
    [dic setObject:tmpUrl forKey:@"url"];
    
    [self linkClickWithPara:dic];
    
    return NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.context = [self.chatWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    BATJSObject *jsObject = [[BATJSObject alloc] init];
    self.context[@"HealthBAT"] = jsObject;
    
    WEAK_SELF(self);
    [jsObject setDrKangPlayMusicBlock:^(NSString *index) {
        STRONG_SELF(self);
        //播放音乐
        if ([self.audioPlayer isPlaying]) {
            [self.audioPlayer stop];
            self.audioPlayer = nil;
        }
        else {
            [self audioPlayerWithIndex:[index intValue]];
        }
    }];
    
    //欢迎语
    [self introductionRequest];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.bottomKeyArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BATDrKangBottomCollectionViewCell *bottomCell = [collectionView dequeueReusableCellWithReuseIdentifier:BOTTOM_CELL forIndexPath:indexPath];
    //    bottomCell.keyLabel.text = self.bottomKeyArray[indexPath.section];
    [bottomCell.keyWordLabel setTitle:self.bottomKeyArray[indexPath.section] forState:UIControlStateNormal];
    
    //    if (self.lastIndexPath && self.lastIndexPath.section == indexPath.section) {
    //        bottomCell.keyLabel.hidden = YES;
    //        bottomCell.keyWordLabel.hidden = NO;
    //    }
    //    else {
    //        bottomCell.keyLabel.hidden = NO;
    //        bottomCell.keyWordLabel.hidden = YES;
    //    }
    
    return bottomCell;
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//
//    return UIEdgeInsetsMake(0, 5, 0, 5);
//}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //    NSString *bottomKey = self.bottomKeyArray[indexPath.section];
    //
    //    CGSize textSize = [bottomKey boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    //    CGSize size = CGSizeMake(textSize.width+20, 30);
    
    CGSize size = CGSizeMake(SCREEN_WIDTH/3.0, 30);
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //    self.lastIndexPath = indexPath;
    //    [self.bottomCollectionView reloadData];
    
    switch (indexPath.section) {
        case 0:
        {
            //只能问诊
            NSString *bottomKey = self.bottomKeyArray[indexPath.section];
            [self sendMsg:bottomKey];
            [self sendTextRequestWithContent:bottomKey isSound:NO];
        }
            break;
        case 1:
        {
            //常见疾病
            [self.view endEditing:YES];
            
            self.diseaseView = nil;
            
            self.diseaseView.dataArray =  @[@"高血压",@"糖尿病",@"心脏病",@"肩周炎",@"颈椎病",@"感冒"];
            [self.navigationController.view addSubview:self.diseaseView];
            [self.diseaseView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(@0);
            }];
        }
            break;
        case 2:
        {
            //历史评估
            BATDrKangHistoryViewController *historyVC = [[BATDrKangHistoryViewController alloc] init];
            [self.navigationController pushViewController:historyVC animated:YES];
        }
            break;
            
        case 3:
        {
            [self pushHealthThreeSecondsVC];
        }
            break;
    }
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    //音频播放完毕
    
}

#pragma mark - YYTextViewDelegate
- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        if ([self.inputBar.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
            return NO;
        }
        [self sendMsg:self.inputBar.textView.text];
        
        [self sendTextRequestWithContent:self.inputBar.textView.text isSound:NO];
        
        self.inputBar.textView.text = @"";
        
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(YYTextView *)textView {
    
    CGSize sizeThatShouldFitTheContent = [textView sizeThatFits:textView.frame.size];
    CGFloat constant = MAX(50, MIN(sizeThatShouldFitTheContent.height + 10 + 10,100));
    //每次textView的文本改变后 修改chatBar的高度
    [self.inputBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(constant);
    }];
    textView.scrollEnabled = self.inputBar.frame.size.height >= 100;
}

- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView {
    
    //解决textView大小不定时 contentOffset不正确的bug
    //固定了textView后可以设置滚动YES
    CGSize sizeThatShouldFitTheContent = [textView sizeThatFits:textView.frame.size];
    //每次textView的文本改变后 修改chatBar的高度
    CGFloat chatBarHeight = MAX(50, MIN(sizeThatShouldFitTheContent.height + 10 + 10,100));
    
    textView.scrollEnabled = chatBarHeight >= 100;
    
    return YES;
}

#pragma mark - IFlySpeechRecognizerDelegate
- (void) onError:(IFlySpeechError *) errorCode {
    
    if (errorCode.errorCode == 20006) {
        
        //录音失败
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            
            if (granted) {
                
                // 用户同意获取麦克风
                
            }
            else {
                //用户未允许麦克风，提示用户
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"麦克风权限已关闭" message:@"请到设置->隐私->麦克风开启权限" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
                    
                    return ;
                }];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:okAction];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
    
    [self bk_performBlock:^(id obj) {
        self.voiceAlertView.hidden = YES;
    } afterDelay:1];
}

- (void) onResults:(NSArray *) results isLast:(BOOL)isLast;
{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];
    _result = [NSString stringWithFormat:@"%@%@", _result,resultFromJson];
    
    if (isLast){
        self.voiceAlertView.hidden = YES;
        
        if (self.result.length == 0) {
            self.result = @"";
            return;
        }
        
        [self sendMsg:self.result];
        [self sendTextRequestWithContent:self.result isSound:YES];
        
        self.result = @"";
    }
}

#pragma mark - IFlySpeechSynthesizerDelegate
//合成结束，此代理必须要实现
- (void) onCompleted:(IFlySpeechError *) error{
    
}
//合成开始
- (void) onSpeakBegin{
    
}
//合成缓冲进度
- (void) onBufferProgress:(int) progress message:(NSString *)msg{
    
}
//合成播放进度
- (void) onSpeakProgress:(int) progress{
    
}

#pragma mark - action
- (void)keyboardWillShow:(NSNotification *)noti {
    
    CGRect keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSInteger animation = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    
    [UIView animateWithDuration:duration delay:duration options:animation animations:^{
        
        [self.bottomCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(-keyboardFrame.size.height-49));
        }];
        [self.inputBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(-keyboardFrame.size.height));
        }];
        [self.chatWebView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(-49-keyboardFrame.size.height-40));
            //            make.bottom.equalTo(@(-keyboardFrame.size.height-40));
        }];
        
        [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        } completion:nil];
        
    } completion:nil];
    
    WEAK_SELF(self);
    [self bk_performBlock:^(id obj) {
        
        STRONG_SELF(self);
        [self scrollToBottom];
    } afterDelay:duration];
}

- (void)keyboardWillHide:(NSNotification *)noti {
    
    double duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    NSInteger animation = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration delay:0.0f options:animation animations:^{
        
        [self.bottomCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@-49);
        }];
        [self.inputBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
        }];
        [self.chatWebView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@-89);
            //            make.bottom.equalTo(@-40);
        }];
        [self.view layoutIfNeeded];
    } completion:nil];
    
    WEAK_SELF(self);
    [self bk_performBlock:^(id obj) {
        
        STRONG_SELF(self);
        [self scrollToBottom];
    } afterDelay:duration];
}

//定位失败
- (void)handleLocationFailure {
    
    
}

//定位成功
- (void)handleLocationInfo:(NSNotification *)locationNotification {
    
    //定位成功过了，不需要去隐私重新设置
    _isFirstLocationFail = NO;
    
    //阻止多次回调
    if (self.isGetLocation) {
        
        return;
    }
    self.isGetLocation = YES;
    
    BMKReverseGeoCodeResult * result = locationNotification.userInfo[@"location"];
    DDLogWarn(@"%@",result);
    
    self.currentLocation = result.location;
}

- (void)evaluationSendMessage:(NSNotification *)evaluationNoti {
    
    NSString *result = evaluationNoti.userInfo[@"result"];
    if ([result isEqualToString:@"1"]) {
        //满意
        [self receiveMsg:@"感谢您的使用，您的满意是我们最大的动力。"];
    }
    else {
        //不满意
        [self receiveMsg:@"感谢您的反馈，我们将持续优化，为您提供更好的服务。"];
        
    }
}


#pragma mark - private
//点击了超链接，判断参数
- (void)linkClickWithPara:(NSDictionary *)dic {
    
    if ([dic.allKeys containsObject:@"flag"]) {
        
        NSString *flag = dic[@"flag"];
        flag = [flag stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        //直接跳转
        if ([flag isEqualToString:@"咨询医生"]) {
            
            [self goConsultation];
            return;
        }else if ([flag isEqualToString:@"健康3秒钟"]){
            
            [self pushHealthThreeSecondsVC];
            
        }
        else if ([flag isEqualToString:@"预约挂号"]) {
            
            if ([dic.allKeys containsObject:@"id"]) {
                //跳转到指定的医院
                NSString *hospitalName = dic[@"hospitalName"];
                hospitalName = [hospitalName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [self goHospitalRegisterWithHospitalID:dic[@"id"] hospitalName:hospitalName];
            }
            else {
                //预约挂号
                [self goHospitalRegister];
            }
            return;
        }
        else if ([flag isEqualToString:@"周边医院"]) {
            
            BATKangDoctorHospitalListViewController *hospitalListVC = [[BATKangDoctorHospitalListViewController alloc] init];
            hospitalListVC.lat = self.currentLocation.latitude;
            hospitalListVC.lon = self.currentLocation.longitude;
            [self.navigationController pushViewController:hospitalListVC animated:YES];
            return;
        }
        else if ([flag isEqualToString:@"快速查病"]) {
            
            
            return;
        }
        else if ([flag isEqualToString:@"telephone"]) {
            
            NSString *content = dic[flag];
            content = [content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",content]]];
            return;
        }
        else if ([flag isEqualToString:@"address"]) {
            
            NSString *oreillyAddress = dic[flag];
            oreillyAddress = [oreillyAddress stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
            [myGeocoder geocodeAddressString:oreillyAddress completionHandler:^(NSArray *placemarks, NSError *error) {
                if ([placemarks count] > 0 && error == nil) {
                    NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
                    CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
                    NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
                    NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
                    self.hospitalLongitude = firstPlacemark.location.coordinate.longitude;
                    self.hospitalLatitude = firstPlacemark.location.coordinate.latitude;
                    
                    [self openUrlWithDestination:dic[@"content"]];
                }
                else if ([placemarks count] == 0 && error == nil) {
                    NSLog(@"Found no placemarks.");
                    
                } else if (error != nil) {
                    NSLog(@"An error occurred = %@", error);
                }
            }];
            
            return;
        }
        
        //发信息，并等待回复
        if (![flag isEqualToString:@"症状列表"] && ![flag isEqualToString:@"展开更多"]) {
            [self sendMsg:flag];
        }
    }
    
    if ([dic.allKeys containsObject:@"url"]) {
        
        NSString *url = dic[@"url"];
        if ([dic.allKeys containsObject:@"resultLength"] && [dic[@"resultLength"] intValue] == -1) {
            //服务器主动加入参数 resultLength=-1 ,展开详情
            
            [self detailRequestWithURL:url];
        }
        else {
            
            url = [NSString stringWithFormat:@"%@&resultLength=%@",url,@(self.maxWordNumber)];
            [self eventRequestWithURL:url];
        }
    }
}

//欢迎语
- (void)welcomeMessage {
    
    /*
     您好，我是康博士。
     有什么我可以帮助的吗？关于快速查病、预约挂号、健康咨询
     都可以找我了解。
     除此之外，我还能为您提供健康管理服务:
     1.依据您提供的数据为您建立健康档案；
     2.对您的健康数据进行个性化的智能风险评估分析；
     3.针对风险评估结果为您提供在线咨询服务。
     */
    NSString *html =
    @"<html>"
    "<head></head>"
    "<body>"
    "<p style=\"margin: 0;color: #333;font-size: 15px;line-height: 22px;\">你好，我是康博士。</p>"
    "<div style=\"margin: 0;color: #333;font-size: 15px;line-height: 22px;\">"
    "有什么我可以帮助的吗？ 关于快速查病、"
    "<a href=\"http://search.jkbat.com/elasticsearch/mrKang?flag=预约挂号\" style=\"text-decoration: none;color: #0182eb;\">预约挂号</a>"
    "<font color=\"#0182eb\">、</font>"
    "<a href=\"http://search.jkbat.com/elasticsearch/mrKang?flag=咨询医生\" style=\"text-decoration: none;color: #0182eb;\">健康咨询</a>都可以找我了解。"
    "</div>"
    "<p style=\"margin: 0;color: #333;font-size: 15px;line-height: 22px;\">除此之外，我还能为您提供健康管理服务:</p>"
    "<p style=\"margin: 0;color: #333;font-size: 15px;line-height: 22px;\">1.依据您提供的数据为您建立健康档案；</p>"
    "<p style=\"margin: 0;color: #333;font-size: 15px;line-height: 22px;\">2.对您的健康数据进行个性化的智能风险评估分析；</p>"
    "<p style=\"margin: 0;color: #333;font-size: 15px;line-height: 22px;\">3.针对风险评估结果为您提供在线咨询服务。</p>"
    "</body>"
    "</html>";
    
    [self receiveMsg:html];
}

- (float)caculateAudioDurationSecondsWith:(int)musicIndex {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",musicIndex] ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:url options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds =CMTimeGetSeconds(audioDuration);
    return audioDurationSeconds;
}

- (void)audioPlayerWithIndex:(int)musicIndex {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",musicIndex] ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.audioPlayer.delegate = self;
    [self.audioPlayer play];
}

//预约挂号
- (void)goHospitalRegisterWithHospitalID:(NSString *)hospitalID hospitalName:(NSString *)hospitalName {
    
    if (!CANREGISTER) {
        [self showText:@"您好,预约挂号功能升级中,请稍后再试!"];
        return;
    }
    
    BATRegisterDepartmentListViewController * departmentListVC = [BATRegisterDepartmentListViewController new];
    departmentListVC.hospitalId = [hospitalID integerValue];
    departmentListVC.hospitalName = hospitalName;
    [self.navigationController pushViewController:departmentListVC animated:YES];
    
}

- (void)goHospitalRegister {
    
    if (!CANREGISTER) {
        [self showText:@"您好,预约挂号功能升级中,请稍后再试!"];
        return;
    }
    
    BATRegisterHospitalListViewController * hospitalVC = [BATRegisterHospitalListViewController new];
    hospitalVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:hospitalVC animated:YES];
    
}

//在线咨询
- (void)goConsultation {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].windows[0].rootViewController;
    [tabBarController setSelectedIndex:3];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:NO];
    });
}

//地图
-(void)openUrlWithDestination:(NSString *)destination {
    
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSString *baiduMapUrl = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",self.hospitalLatitude,self.hospitalLongitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([self isCanOpenUrlWithString:baiduMapUrl]) {
        
        UIAlertAction *baidumap = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self openURLWithString:baiduMapUrl];
        }];
        
        [alter addAction:baidumap];
    }
    
    NSString *gaodeMapUrl = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%f&slon=%f&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&m=0&t=0",self.currentLocation.latitude,self.currentLocation.longitude,@"我的位置",self.hospitalLatitude,self.hospitalLongitude,destination]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([self isCanOpenUrlWithString:gaodeMapUrl]) {
        
        UIAlertAction *gaodedmap = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self openURLWithString:gaodeMapUrl];
        }];
        
        [alter addAction:gaodedmap];
    }
    
    NSString *aaMapUrl = [NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&fromcoord=%f,%f&tocoord=%f,%f&policy=1",self.currentLocation.latitude,self.currentLocation.longitude,self.hospitalLatitude,self.hospitalLongitude];
    if ([self isCanOpenUrlWithString:aaMapUrl]) {
        
        UIAlertAction *qqmap = [UIAlertAction actionWithTitle:@"腾讯地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self openURLWithString:aaMapUrl];
        }];
        
        [alter addAction:qqmap];
    }
    
    UIAlertAction *acton = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(self.hospitalLatitude,self.hospitalLongitude);
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                       MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    }];
    [alter addAction:acton];
    
    UIAlertAction *cancleacton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alter addAction:cancleacton];
    
    
    [self presentViewController:alter animated:YES completion:nil];
}

-(void)openURLWithString:(NSString *)urlString {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

-(bool)isCanOpenUrlWithString:(NSString *)urlString {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
        
        return YES;
    }
    else {
        
        return NO;
    }
}

/**
 跳转到健康3秒钟界面
 */
- (void)pushHealthThreeSecondsVC{
    
    /*
    if ( !LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }
    
    BATPerson *loginUserModel = PERSON_INFO;
    
    BOOL isEdit = (loginUserModel.Data.Weight && loginUserModel.Data.Height && loginUserModel.Data.Birthday.length);
    
    if ( !LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }
    
    
    if (!isEdit && ![[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstEnterHealthThreeSecond"]) {
        
        //完善资料
        BATHealthyInfoViewController *editInfo = [[BATHealthyInfoViewController alloc]init];
        editInfo.isShowNavButton = YES;
        editInfo.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:editInfo animated:YES];
        
        
    }else{
        
        //健康3秒钟
        BATHealthThreeSecondsController *healthThreeSecondsVC = [[BATHealthThreeSecondsController alloc]init];
        healthThreeSecondsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:healthThreeSecondsVC animated:YES];
    }
     */
}

#pragma mark - net
- (void)sendTextRequestWithContent:(NSString *)content isSound:(BOOL)isSound {
    
    //发送新消息，停止语音回答
    [self.iFlySpeechSynthesizer stopSpeaking];
    
    BATLoginModel *login = LOGIN_INFO;
    
    [HTTPTool requestWithSearchURLString:@"/elasticsearch/DrKang/chatWithDrKang"
                              parameters:@{
                                           @"keyword":content,
                                           @"userDeviceId":[Tools getPostUUID],
                                           @"userId":@(login.Data.ID),
                                           @"lat":@(self.currentLocation.latitude),
                                           @"lon":@(self.currentLocation.longitude),
                                           }
                                 success:^(id responseObject) {
                                     
                                     if (!responseObject) {
                                         
                                         return ;
                                     }
                                     self.title = @"对方正在输入...";
                                     
                                     BATDrKangModel *model = [BATDrKangModel mj_objectWithKeyValues:responseObject];
                                     
                                     if ([model.resultData.type isEqualToString:@"music"]) {
                                         //音频消息
                                         
                                         [self bk_performBlock:^(id obj) {
                                             self.title = @"康博士";
                                             
                                             [self receiveMusic:[NSString stringWithFormat:@"%d",[Tools getRandomNumber:1 to:5]]];
                                             
                                         } afterDelay:1.5];
                                         return;
                                     }
                                     
                                     //文字消息
                                     
                                     [self bk_performBlock:^(id obj) {
                                         self.title = @"康博士";
                                         
                                         
                                         
                                         [self receiveMsg:model.resultData.body];
                                         
                                         
                                         
                                         if (isSound) {
                                             
                                             if ([model.resultData.type isEqualToString:@"chat"] ||
                                                 [model.resultData.type isEqualToString:@"ackBack"] ||
                                                 [model.resultData.type isEqualToString:@"recommend_chat"]) {
                                                 
                                                 NSString *string = [[Tools filterHTML:model.resultData.body] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""]];
                                                 string = [string stringByReplacingOccurrencesOfString:@"～" withString:@" "];
                                                 string = [string stringByReplacingOccurrencesOfString:@"_" withString:@" "];
                                                 
                                                 DDLogDebug(@"%@",string);
                                                 
                                                 [self.iFlySpeechSynthesizer startSpeaking:string];
                                             }
                                             else {
                                                 
                                                 [self.iFlySpeechSynthesizer startSpeaking:@"这些是我搜集到的信息"];
                                             }
                                             
                                         }
                                     } afterDelay:1.5];
                                     
                                 } failure:^(NSError *error) {
                                     self.title = @"康博士";
                                     
                                 }];
}

- (void)eventRequestWithURL:(NSString *)url {
    
    //发送新消息，停止语音回答
    [self.iFlySpeechSynthesizer stopSpeaking];
    
    
    BATLoginModel *login = LOGIN_INFO;
    url = [NSString stringWithFormat:@"%@&userDeviceId=%@&userId=%ld",url,[Tools getPostUUID],(long)login.Data.ID];
    
    [XMCenter sendRequest:^(XMRequest *request) {
        request.url = url;
        request.httpMethod = kGET;
        request.requestSerializerType = kXMRequestSerializerRAW;
    } onSuccess:^(id responseObject) {
        if (!responseObject) {
            
            return ;
        }
        
        BATDrKangModel *model = [BATDrKangModel mj_objectWithKeyValues:responseObject];
        
        if ([url rangeOfString:@"getSymptomList"].location != NSNotFound &&
            [url rangeOfString:@"size=10000"].location != NSNotFound) {
            //症状列表
            self.diseaseView = nil;
            self.diseaseView.dataArray =  model.resultData.symptomList;
            [self.navigationController.view addSubview:self.diseaseView];
            [self.diseaseView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(@0);
            }];
            return;
        }
        
        self.title = @"对方正在输入...";
        [self bk_performBlock:^(id obj) {
            self.title = @"康博士";
            
            [self receiveMsg:model.resultData.body];
            
        } afterDelay:1.5];
        
    } onFailure:^(NSError *error) {
        
        self.title = @"康博士";
        
        
    } onFinished:^(id responseObject, NSError *error) {
        
        
    }];
}

- (void)detailRequestWithURL:(NSString *)url {
    
    //停止语音回答
    [self.iFlySpeechSynthesizer stopSpeaking];
    
    BATLoginModel *login = LOGIN_INFO;
    url = [NSString stringWithFormat:@"%@&userDeviceId=%@&userId=%ld",url,[Tools getPostUUID],(long)login.Data.ID];
    
    [XMCenter sendRequest:^(XMRequest *request) {
        request.url = url;
        request.httpMethod = kGET;
        request.requestSerializerType = kXMRequestSerializerRAW;
    } onSuccess:^(id responseObject) {
        
        if (!responseObject) {
            
            return ;
        }
        
        BATDrKangModel *model = [BATDrKangModel mj_objectWithKeyValues:responseObject];
        
        //展开详情
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 6.5;// 字体的行间距
        
        NSDictionary *attributes = @{
                                     NSForegroundColorAttributeName :UIColorFromRGB(51, 51, 51, 1),
                                     NSFontAttributeName:[UIFont systemFontOfSize:16],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        self.detailView.detailTextView.attributedText = [[NSAttributedString alloc] initWithString:model.resultData.body attributes:attributes];
        
        
        [self.navigationController.view addSubview:self.detailView];
        [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        
        
    } onFailure:^(NSError *error) {
        
        
        
    } onFinished:^(id responseObject, NSError *error) {
        
        
    }];
}

- (void)introductionRequest {
    
    [HTTPTool requestWithSearchURLString:@"/elasticsearch/DrKang/getIntroductionNew" parameters:@{@"userDeviceId":[Tools getPostUUID]} success:^(id responseObject) {
        
        BATDrKangIntroductionModel *introductionModel = [BATDrKangIntroductionModel mj_objectWithKeyValues:responseObject];
        
        for (NSString *string in introductionModel.resultData.body) {
            
            [self receiveMsg:string];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - layout
- (void)layoutPages {
    
    [self.view addSubview:self.chatWebView];
    [self.chatWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.bottom.equalTo(@-89);
    }];
    
    [self.view addSubview:self.bottomCollectionView];
    [self.bottomCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@-49);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.inputBar];
    [self.inputBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.mas_equalTo(49);
    }];
    
    [self.view addSubview:self.voiceAlertView];
    [self.voiceAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
    }];
}

#pragma mark - getter
- (UIWebView *)chatWebView {
    
    if (!_chatWebView) {
        _chatWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _chatWebView.delegate = self;
        //        _chatWebView.scrollView.delegate = self;
        //        _chatWebView.multipleTouchEnabled=NO;
        _chatWebView.scrollView.scrollEnabled = NO;
        _chatWebView.scrollView.showsVerticalScrollIndicator = NO;
        _chatWebView.backgroundColor = BASE_BACKGROUND_COLOR;
        _chatWebView.scrollView.backgroundColor = BASE_BACKGROUND_COLOR;
    }
    return _chatWebView;
}

- (UICollectionView *)bottomCollectionView {
    
    if (!_bottomCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _bottomCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _bottomCollectionView.backgroundColor = BASE_BACKGROUND_COLOR;
        _bottomCollectionView.showsHorizontalScrollIndicator = NO;
        _bottomCollectionView.delegate = self;
        _bottomCollectionView.dataSource = self;
        
        [_bottomCollectionView registerClass:[BATDrKangBottomCollectionViewCell class] forCellWithReuseIdentifier:BOTTOM_CELL];
    }
    return _bottomCollectionView;
}

- (BATDrKangInputBar *)inputBar {
    
    if (!_inputBar) {
        
        _inputBar = [[BATDrKangInputBar alloc] initWithFrame:CGRectZero];
        _inputBar.textView.delegate = self;
        WEAK_SELF(self);
        [_inputBar setSendTextMessageBlock:^{
            STRONG_SELF(self);
            if ([self.inputBar.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
                return ;
            }
            
            [self sendMsg:self.inputBar.textView.text];
            
            [self sendTextRequestWithContent:self.inputBar.textView.text isSound:NO];
            
            self.inputBar.textView.text = @"";
        }];
        
        //开始语音识别
        [_inputBar setRecognizerBeginBlock:^{
            STRONG_SELF(self);
            
            [self.iFlySpeechRecognizer cancel];
            [self.iFlySpeechSynthesizer stopSpeaking];//语音输入时停止语音回答
            
            [self.iFlySpeechRecognizer startListening];
            
            self.voiceAlertView.image = [UIImage imageNamed:@"icon-qxfs"];
            self.voiceAlertView.hidden = NO;
            
        }];
        
        [_inputBar setRecognizerStopBlock:^{
            STRONG_SELF(self);
            
            [self.iFlySpeechRecognizer stopListening];
            
        }];
        
        [_inputBar setRecognizerAlertBlock:^{
            STRONG_SELF(self);
            self.voiceAlertView.image = [UIImage imageNamed:@"icon-sksz"];
            self.voiceAlertView.hidden = NO;
            
        }];
        
        [_inputBar setRecognizerCancelBlock:^{
            STRONG_SELF(self);
            self.voiceAlertView.hidden = YES;
            [self.iFlySpeechRecognizer cancel];
        }];
        
        [_inputBar setRecognizerContinueBlock:^{
            STRONG_SELF(self);
            self.voiceAlertView.image = [UIImage imageNamed:@"icon-qxfs"];
            self.voiceAlertView.hidden = NO;
            
        }];
    }
    return _inputBar;
}

- (UIImageView *)voiceAlertView {
    
    if (!_voiceAlertView) {
        _voiceAlertView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-qxfs"]];
        [_voiceAlertView sizeToFit];
        _voiceAlertView.hidden = YES;
    }
    return _voiceAlertView;
}

- (BATDrKangDetailView *)detailView {
    
    if (!_detailView) {
        _detailView = [[BATDrKangDetailView alloc] initWithFrame:CGRectZero];
        WEAK_SELF(self);
        [_detailView setDownBlock:^{
            STRONG_SELF(self);
            [self.detailView removeFromSuperview];
        }];
    }
    return _detailView;
}

- (BATDrKangDiseaseView *)diseaseView {
    
    if (!_diseaseView) {
        _diseaseView = [[BATDrKangDiseaseView alloc] initWithFrame:CGRectZero];
        WEAK_SELF(self);
        [_diseaseView setDownBlock:^{
            STRONG_SELF(self);
            [self.diseaseView removeFromSuperview];
        }];
        
        [_diseaseView setSelectedDisease:^(NSString *disease){
            
            STRONG_SELF(self);
            [self.diseaseView removeFromSuperview];
            [self sendMsg:disease];
            [self sendTextRequestWithContent:disease isSound:NO];
            
        }];
        
        [_diseaseView setTopBlock:^{
            
            STRONG_SELF(self);
            [self.diseaseView removeFromSuperview];
        }];
    }
    return _diseaseView;
}

- (IFlySpeechRecognizer *)iFlySpeechRecognizer {
    
    if (!_iFlySpeechRecognizer) {
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        _iFlySpeechRecognizer.delegate = self;
        
        //设置最长录音时间
        [_iFlySpeechRecognizer setParameter:@"60000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        //        [_iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        //        [_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        
        //网络等待时间
        [_iFlySpeechRecognizer setParameter:@"30000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [_iFlySpeechRecognizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        //设置语言
        [_iFlySpeechRecognizer setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];
        //设置方言
        [_iFlySpeechRecognizer setParameter:@"mandarin" forKey:[IFlySpeechConstant ACCENT]];
        //设置是否返回标点符号
        [_iFlySpeechRecognizer setParameter:@"1" forKey:[IFlySpeechConstant ASR_PTT]];
        
    }
    return _iFlySpeechRecognizer;
}

- (IFlySpeechSynthesizer *)iFlySpeechSynthesizer {
    
    if (!_iFlySpeechSynthesizer) {
        // 创建合成对象，为单例模式
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
        _iFlySpeechSynthesizer.delegate = self;
        //设置语音合成的参数
        //语速,取值范围 0~100
        [_iFlySpeechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];
        //音量;取值范围 0~100
        [_iFlySpeechSynthesizer setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]];
        //发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表
        [_iFlySpeechSynthesizer setParameter:@"vixq" forKey: [IFlySpeechConstant VOICE_NAME]];
        //音频采样率,目前支持的采样率有 16000 和 8000
        [_iFlySpeechSynthesizer setParameter:@"8000" forKey: [IFlySpeechConstant SAMPLE_RATE]];
        //asr_audio_path保存录音文件路径，如不再需要，设置value为nil表示取消，默认目录是documents
        [_iFlySpeechSynthesizer setParameter:nil forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
        //        [_iFlySpeechSynthesizer setParameter:@"tts.pcm" forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
        //启动合成会话
        
    }
    return _iFlySpeechSynthesizer;
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


