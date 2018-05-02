//
//  BATQuickConsultationViewController.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/10/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATQuickConsultationViewController.h"
#import "BATKmWlyyOPDRegisteModel.h"
#import "BATWlyyOrgIDModel.h"

#import "BATWriteSingleDiseaseView.h"
#import "BATTitleTableViewCell.h"
#import "BATWriteTextViewTableViewCell.h"
#import "BATAddPicTableViewCell.h"
#import "BATDiseaseDescriptionModel.h"
#import "BATPerson.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "BATUploadImageModel.h"
#import "BATChooseEntiyModel.h"
#import "BATChatConsultController.h"
#import <Photos/Photos.h>
#import "BATNetWorkMedicalImageModel.h"
#import "BATHealthFilesListVC.h"
#import "BATPhotoBrowserController.h"

#import "BATWaitingRoomViewController.h"

@interface BATQuickConsultationViewController ()<UITableViewDelegate,UITableViewDataSource,BATWriteSingleDiseaseViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,BATAddPicTableViewCellDelegate,TZImagePickerControllerDelegate,YYTextViewDelegate>

@property (nonatomic,strong) NSString *orgID;

/**
 *  view
 */
@property (nonatomic,strong) BATWriteSingleDiseaseView *writeSingleDiseaseView;

/**
 *  图片数组
 */
@property (nonatomic,strong) NSMutableArray *picDataSource;

/**
 *  图片asset信息数据源
 */
@property (nonatomic,strong) NSMutableArray *picAsset;

/**
 *  待上传的图片数组URL
 */
@property (nonatomic,strong) NSMutableArray *picArray;


/**
 *  病症描述
 */
@property (nonatomic,strong) NSString *diseaseDescription;

/**
 *  家庭成员
 */
@property (nonatomic,strong) MyResData *myResData;


/**
 *  memberID
 */
@property (nonatomic,strong) NSString  *memberID;

@property (nonatomic,strong) NSString *beginTime;

/**
 临时数据
 */
@property (nonatomic,strong) NSMutableArray *tempPicArray;

@property (nonatomic,assign) NSInteger count;

@end

@implementation BATQuickConsultationViewController

- (void)dealloc
{
    _writeSingleDiseaseView.tableView.delegate = nil;
    _writeSingleDiseaseView.tableView.dataSource = nil;
    _writeSingleDiseaseView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView
{
    [super loadView];
    
    if (_writeSingleDiseaseView == nil) {
        _writeSingleDiseaseView = [[BATWriteSingleDiseaseView alloc] init];
        _writeSingleDiseaseView.tableView.delegate = self;
        _writeSingleDiseaseView.tableView.dataSource = self;
        _writeSingleDiseaseView.delegate = self;
        [self.view addSubview:_writeSingleDiseaseView];
        
        WEAK_SELF(self)
        [_writeSingleDiseaseView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
    }
    
    self.title = @"处方问诊";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
    _picDataSource = [NSMutableArray array];
    _tempPicArray = [NSMutableArray array];
    _picArray = [NSMutableArray array];
    _count = 0;
    
    [_writeSingleDiseaseView.tableView registerClass:[BATTitleTableViewCell class] forCellReuseIdentifier:@"TitleTableViewCell"];
    [_writeSingleDiseaseView.tableView registerClass:[BATWriteTextViewTableViewCell class] forCellReuseIdentifier:@"WriteTextViewTableViewCell"];
    [_writeSingleDiseaseView.tableView registerClass:[BATAddPicTableViewCell class] forCellReuseIdentifier:@"AddPicTableViewCell"];
    
    [self requestGetDefaultUserMembers];
    
    [self getOrgIDRequest];
    
    if ([[BATTIMManager sharedBATTIM] bat_getLoginStatus] == NO) {
        
        [[BATTIMManager sharedBATTIM] bat_loginTIM];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        return 105;
    }
    
    if (indexPath.section == 2) {
    
        NSInteger picCount = _picDataSource.count < 9 ? _picDataSource.count + 1 : _picDataSource.count;
        
        if (picCount <= 4) {
            return ItemWidth + 30;
        }
        else if (picCount <= 8) {
            return 2 * ItemWidth + 10 + 30;
        }
        else {
            return 3 * ItemWidth + 20 + 30;
        }
        
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 2){
        return CGFLOAT_MIN;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        BATTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleTableViewCell" forIndexPath:indexPath];
        NSString *string = _myResData != nil ? [NSString stringWithFormat:@"就诊人信息: %@",_myResData.MemberName] : @"就诊人信息: 请选择就诊人信息";
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(5, string.length - 5)];
        
        cell.textLabel.attributedText = attributedString;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            BATWriteTextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WriteTextViewTableViewCell" forIndexPath:indexPath];
            cell.textView.delegate = self;
            cell.textView.tag = indexPath.section;
            cell.textView.placeholderText = @"请详细描述您的身体状况和病情，我们将会在24小时内回复您（最少20个字符）";
            cell.wordCountLabel.text = [NSString stringWithFormat:@"%ld/600",(unsigned long)_diseaseDescription.length];
            
            return cell;
        }
    }
    else if (indexPath.section == 2){
        BATAddPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddPicTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell reloadCollectionViewData:_picDataSource];
        return cell;

    }
    return nil;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //选择就诊人信息
            BATHealthFilesListVC *chooseTreatmentPersonVC = [[BATHealthFilesListVC alloc] init];
            chooseTreatmentPersonVC.isConsultionAndAppointmentYes = YES;
            [chooseTreatmentPersonVC setChooseBlock:^(ChooseTreatmentModel *chooseTreatmentModel) {
                
                _myResData = [[MyResData alloc] init];
                _myResData.MemberName = chooseTreatmentModel.name;
                _myResData.MemberID = chooseTreatmentModel.memberID;
                _myResData.UserID = chooseTreatmentModel.userID;
                _myResData.Mobile = chooseTreatmentModel.phoneNumber;
                _myResData.IsPerfect = chooseTreatmentModel.IsPerfect;
                self.memberID = chooseTreatmentModel.memberID;
                [_writeSingleDiseaseView.tableView reloadData];
                
            }];
            
            chooseTreatmentPersonVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chooseTreatmentPersonVC animated:YES];
        }
    }
}

#pragma mark YYTextViewDelegate

- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView {
    return YES;
}

- (void)textViewDidChange:(YYTextView *)textView
{
    BATWriteTextViewTableViewCell *cell = [_writeSingleDiseaseView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:textView.tag]];
    
    
    //获取填写的病症描述
    if (textView.text.length >= 600) {
        [self showText:@"病症描述最多600个字符"];
        textView.text = [textView.text substringToIndex:600];
    }
    _diseaseDescription = textView.text;
    cell.wordCountLabel.text = [NSString stringWithFormat:@"%ld/600",(unsigned long)_diseaseDescription.length];

}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //实现textView.delegate  实现回车发送,return键发送功能
    if ([@"\n" isEqualToString:text]) {
        DDLogDebug(@"发送");
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - BATAddPicTableViewCellDelegate
- (void)collectionViewItemClicked:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
    if (indexPath.row == _picDataSource.count) {
        
        _count = 0;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传图片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        
        WEAK_SELF(self);
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            STRONG_SELF(self);
            [self getPhotosFromCamera];
        }];
        
        UIAlertAction *photoGalleryAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            STRONG_SELF(self);
            [self getPhotosFromLocal];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:cameraAction];
        [alertController addAction:photoGalleryAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        [self deletePic:indexPath];
        
    }
}

#pragma mark - WriteSingleDiseaseViewDelegate
- (void)consultBtnClickedAction {
    
    [self.view endEditing:YES];
    
    _writeSingleDiseaseView.footerView.consultBtn.enabled = NO;
    
    if (_myResData == nil) {
        [self showErrorWithText:@"请选择就诊人"];
        
        _writeSingleDiseaseView.footerView.consultBtn.enabled = YES;
        return;
    }
    
    if (!_myResData.IsPerfect) {
        [self showText:@"请完善就诊人信息"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BATHealthFilesListVC *filedVC = [[BATHealthFilesListVC alloc]init];
            filedVC.isConsultionAndAppointmentYes = YES;
            [self.navigationController pushViewController:filedVC animated:YES];
        });
        return;
    }
    
    if (_diseaseDescription.length <= 0 || !_diseaseDescription) {
        [self showErrorWithText:@"病症描述不能为空"];
        _writeSingleDiseaseView.footerView.consultBtn.enabled = YES;
        return;
    } else if (_diseaseDescription.length < 20) {
        [self showErrorWithText:@"病症描述需要填入最少20个字符"];
        _writeSingleDiseaseView.footerView.consultBtn.enabled = YES;
        return;
    }
    
    //一件预约
    [self wlyyRegistersRequest];
}

#pragma mark - 从本地相册获取图片
- (void)getPhotosFromLocal
{
    
    TZImagePickerController *tzImagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:(9 - _picDataSource.count) delegate:self];
    tzImagePickerVC.allowPickingVideo = NO;

    // 你可以通过block或者代理，来得到用户选择的照片.
    [tzImagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

        [_tempPicArray removeAllObjects];
        if (photos.count > 0) {
            for (UIImage *image in photos) {
                //对图片进行压缩处理
                if (isSelectOriginalPhoto) {
                    [_tempPicArray addObject:image];
                }
                else {
                    UIImage *imageCompress = [Tools compressImageWithImage:image ScalePercent:0.05];
                    [_tempPicArray addObject:imageCompress];
                }
            }
        }
        [self requestUpdateImages];

    }];
    
    [self presentViewController:tzImagePickerVC animated:YES completion:nil];
    
}

#pragma mark - 从相机中获取图片
- (void)getPhotosFromCamera
{
    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];//相机权限
    
    switch (AVstatus) {
        case AVAuthorizationStatusAuthorized:
            DDLogDebug(@"Authorized");
            break;
        case AVAuthorizationStatusDenied:
        {
            DDLogDebug(@"Denied");
            //提示开启相机
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"相机权限已关闭" message:@"请到设置->隐私->相机开启权限" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
                
                return ;
            }];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:okAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
            break;
        case AVAuthorizationStatusNotDetermined:
            DDLogDebug(@"not Determined");
            break;
        case AVAuthorizationStatusRestricted:
            DDLogDebug(@"Restricted");
            break;
        default:
            break;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        NSLog(@"模拟器中无法打开相机，请在真机中使用");
    }
}

#pragma mark 删除图片
- (void)deletePic:(NSIndexPath *)indexPath
{
    BATPhotoBrowserController *browserVC = [[BATPhotoBrowserController alloc]init];
    browserVC.BrowserPicAssetArr = _picArray;
    browserVC.BrowserPicDataSourceArr = _picDataSource;
    browserVC.index = indexPath.item;
    browserVC.iSReloadBlock = ^(NSMutableArray *BrowserPicDataSourceArr,NSMutableArray *BrowserDynamicImgArray,NSMutableArray *BrowserPicAssetArr) {
        _picArray = BrowserPicAssetArr;
        _picDataSource = BrowserPicDataSourceArr;
        [_writeSingleDiseaseView.tableView reloadData];
    };
    [self.navigationController pushViewController:browserVC animated:YES];
}



#pragma mark - net
- (void)getOrgIDRequest {
    
    [HTTPTool requestWithOTCURLString:@"/api/OtcConsult/GetOrgID" parameters:nil type:kGET success:^(id responseObject) {
        
        BATWlyyOrgIDModel *orgIDModel = [BATWlyyOrgIDModel mj_objectWithKeyValues:responseObject];
        
        if (orgIDModel.Data.length > 0) {
            self.orgID = orgIDModel.Data;
        }
        
    } failure:^(NSError *error) {
        
    }];
}
//一键预约接口
- (void)wlyyRegistersRequest {
    
    [self showProgress];
    
    NSMutableArray *files = [[NSMutableArray alloc] init];
    
    for (BATNetWorkMedicalImageModel *batImage in _picArray) {
        [files addObject:@{@"FileUrl":batImage.Data.FileName,@"Remark":@"一键预约"}];
    }

    if (self.orgID == nil || self.orgID.length == 0) {
     
        [self showErrorWithText:@"数据错误，请稍后再试"];
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"MemberID":_myResData.MemberID,
                                 @"OPDType":@"3",
                                 @"ConsultContent":_diseaseDescription,
                                 @"Fileslst":[Tools dataTojsonString:files],
                                 @"AllergicHistory":@"无",
                                 @"Privilege":@"6",
                                 @"OrgnazitionID":self.orgID,
                                 };
    
    [HTTPTool requestWithKmWlyyBaseApiURLString:@"/UserOPDRegisters" parameters:parameters type:kPOST success:^(id responseObject) {
       
        if ([[BATTIMManager sharedBATTIM] bat_getLoginStatus] == NO) {
            
            [self showErrorWithText:@"通信异常，请稍后再试"];
            return ;
        }
        
        _writeSingleDiseaseView.footerView.consultBtn.enabled = YES;

        BATKmWlyyOPDRegisteModel *registeModel = [BATKmWlyyOPDRegisteModel mj_objectWithKeyValues:responseObject];
        
        if ([registeModel.Data.ActionStatus isEqualToString:@"Success"]) {
            //预约成功
            
            [self showSuccessWithText:@"预约成功"];
            
            //跳转等待呼叫的界面
            [self bk_performBlock:^(id obj) {
                
                BATWaitingRoomViewController *waitingVC = [[BATWaitingRoomViewController alloc] init];
                waitingVC.roomID = [registeModel.Data.ChannelID integerValue];
                waitingVC.type = kDoctorServerVideoType;
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:waitingVC];
                
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];

            } afterDelay:2];
            
            //退出预约界面
            [self bk_performBlock:^(id obj) {
                
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:3];

        }
        else if ([registeModel.Data.ActionStatus isEqualToString:@"Repeat"]) {
            
            [self showSuccessWithText:@"已经预约，正在进入诊室"];
            
            //跳转等待呼叫的界面
            [self bk_performBlock:^(id obj) {
                
                BATWaitingRoomViewController *waitingVC = [[BATWaitingRoomViewController alloc] init];
                waitingVC.roomID = [registeModel.Data.ChannelID integerValue];
                waitingVC.type = kDoctorServerVideoType;
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:waitingVC];
                
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
                
            } afterDelay:2];
            
            //退出预约界面
            [self bk_performBlock:^(id obj) {
                
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:3];
        }
        else {
            [self showErrorWithText:registeModel.Data.ErrorInfo];
        }

    } failure:^(NSError *error) {
       
        _writeSingleDiseaseView.footerView.consultBtn.enabled = YES;

        [self showErrorWithText:error.localizedDescription];
    }];
}

//获取默认就诊人
- (void)requestGetDefaultUserMembers
{
    [self showProgressWithText:@"正在加载"];
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetDefaultUserMembers" parameters:nil type:kGET success:^(id responseObject) {
        
        BATChooseEntiyModel *chooseEntiyModel = [BATChooseEntiyModel mj_objectWithKeyValues:responseObject];
        if (chooseEntiyModel.Data.count > 0) {
            self.memberID = [chooseEntiyModel.Data[0] MemberID];
            _myResData = chooseEntiyModel.Data[0];
        }
        
        [_writeSingleDiseaseView.tableView reloadData];
        
        if (!_myResData.IsPerfect) {
            [self showText:@"请完善就诊人信息"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                BATHealthFilesListVC *filedVC = [[BATHealthFilesListVC alloc]init];
                filedVC.isConsultionAndAppointmentYes = YES;
                [filedVC setChooseBlock:^(ChooseTreatmentModel *chooseTreatmentModel) {
         
                    _myResData.MemberName = chooseTreatmentModel.name;
                    _myResData.MemberID = chooseTreatmentModel.memberID;
                    _myResData.UserID = chooseTreatmentModel.userID;
                    _myResData.Mobile = chooseTreatmentModel.phoneNumber;
                    _myResData.IsPerfect = chooseTreatmentModel.IsPerfect;
                    
                    self.memberID = chooseTreatmentModel.memberID;
                    [_writeSingleDiseaseView.tableView reloadData];
                }];
                [self.navigationController pushViewController:filedVC animated:YES];
            });
        }else {
            [self dismissProgress];
        }
        
    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];
    }];
}

#pragma mark - 批量上传图片
- (void)requestUpdateImages
{
    NSMutableArray *imageArray = [NSMutableArray array];
    // 将本地的文件上传至服务器
    for (int i = 0; i < [_tempPicArray count]; i++) {
        UIImage *image = [_tempPicArray objectAtIndex:i];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
        [imageArray addObject:imageData];
    }
    
    [HTTPTool requestUploadImageToKMWithParams:imageArray success:^(NSArray *severImageArray) {
        
        [self dismissProgress];
        [_picDataSource addObjectsFromArray:_tempPicArray];
        [_picArray addObjectsFromArray:[BATNetWorkMedicalImageModel mj_objectArrayWithKeyValuesArray:severImageArray]];
        [_writeSingleDiseaseView.tableView reloadData];
    } failure:^(NSError *error) {
        
        _count++;
        
        if (_count == 3) {
            _count = 0;
            [self showErrorWithText:@"图片上传失败！"];
        } else {
            [self requestUpdateImages];
        }
        
        
    } fractionCompleted:^(double count) {
        
        [self showProgress];
    }];
    
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
