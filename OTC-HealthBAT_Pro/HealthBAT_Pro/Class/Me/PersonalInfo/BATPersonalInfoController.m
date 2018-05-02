//
//  BATPersonalInfoController.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATPersonalInfoController.h"
#import "BATPerson.h"
#import "BATPersonalInfoTextCell.h"
#import "BATPersonalInfoImageCell.h"
#import "BATEditPersonalInfoController.h"
#import <AVFoundation/AVFoundation.h>
#import "STPickerSingle.h"
#import "STPickerView.h"

@interface BATPersonalInfoController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, BATEditPersonalInfoControllerDelegate, STPickerSingleDelegate>

/** tableView */
@property (nonatomic ,strong) UITableView *tableView;
/** model */
@property (nonatomic ,strong) BATPerson *userModel;
/** 保存之前的数据 */
@property (nonatomic ,strong) NSString *oldDataStr;

@end

@implementation BATPersonalInfoController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人主页";
    [self requestGetPersonInfoList];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 56;
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        BATPersonalInfoImageCell *imageCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BATPersonalInfoImageCell class])];
        imageCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        imageCell.titleLabel.text = @"头       像";
        [imageCell.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.Data.PhotoPath] placeholderImage:[UIImage imageNamed:@"用户"]];
        
        return imageCell;
    }else{
        BATPersonalInfoTextCell *
        textCell= [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BATPersonalInfoTextCell class])];
        textCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 1) {
            textCell.titleLabel.text = @"手机号码";
            textCell.textSubLabel.text = self.userModel.Data.PhoneNumber;
            //手机号暂时不能修改
            textCell.accessoryType = UITableViewCellAccessoryNone;
        }else if (indexPath.row == 2){
            textCell.titleLabel.text = @"昵       称";
            textCell.textSubLabel.text = self.userModel.Data.UserName;
            
        }else if (indexPath.row == 3){
            textCell.titleLabel.text = @"性       别";
            textCell.textSubLabel.text = [self.userModel.Data.Sex isEqualToString:@"1"] ? @"男" : @"女";
            
        }else if (indexPath.row == 4){
            textCell.titleLabel.text = @"已往病史";
            
            textCell.textSubLabel.text = self.userModel.Data.Anamnese.length ? self.userModel.Data.Anamnese : @"无已往病史";
            
            
        }else if (indexPath.row == 5){
            textCell.titleLabel.text = @"过敏病史";
            textCell.textSubLabel.text = self.userModel.Data.Allergies.length ? self.userModel.Data.Allergies : @"无过敏史";
            
        }else if (indexPath.row == 6){
            textCell.titleLabel.text = @"遗传病史";
            textCell.textSubLabel.text = self.userModel.Data.GeneticDisease.length ? self.userModel.Data.GeneticDisease : @"无家族遗传病";
            
        }else if (indexPath.row == 7){
            textCell.titleLabel.text = @"个性签名";
            textCell.textSubLabel.text = self.userModel.Data.Signature.length ? self.userModel.Data.Signature : @"这家伙很懒，什么都没有留下";
            
        }
        
        return textCell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BATEditPersonalInfoController *editVc = [[BATEditPersonalInfoController alloc]init];
    editVc.delegate = self;
    if (indexPath.row == 1) { //手机号码，暂时不能修改
        
        return;
    }else if (indexPath.row == 0) {  //头像
        
        [self showAlertAction];
        
        
    }else if (indexPath.row == 2) {  
        
        editVc.placehoder =@"昵称最多只能输入10位";
        editVc.textViewText = self.userModel.Data.UserName;
        editVc.title = @"昵称";
        editVc.maxInputLimit = 10;
        editVc.editType = kEditUserName;
        
    }else if (indexPath.row == 3){
        //弹出性别选择视图
        [self presentPickerView];
        return;
    }else if (indexPath.row == 4){
        editVc.placehoder =@"请描述您的已往病史...";
        editVc.textViewText = self.userModel.Data.Anamnese;
        editVc.maxInputLimit = 30;
        editVc.editType = kEditPastHistory;
        editVc.title = @"已往病史";
    }else if (indexPath.row == 5){
        editVc.placehoder =@"请输入...";
        editVc.textViewText = self.userModel.Data.Allergies;
        editVc.maxInputLimit = 10;
        editVc.editType = kEditAllergyHistory;
        editVc.title = @"过敏病史";
    }else if (indexPath.row == 6){
        editVc.placehoder =@"请输入...";
        editVc.textViewText = self.userModel.Data.GeneticDisease;
        editVc.maxInputLimit = 30;
        editVc.editType = kEditHereditaryDisease;
        editVc.title = @"遗传病史";
    }else {
        editVc.placehoder =@"请输入...";
        editVc.textViewText = self.userModel.Data.Signature;
        editVc.maxInputLimit = 20;
        editVc.title = @"个性签名";
        editVc.editType = kEditSignature;
        
    }
    
    [self.navigationController pushViewController:editVc animated:YES];
    
}

#pragma mark - 弹出性别选择器
- (void)presentPickerView{
    
    NSMutableArray *dataM = [NSMutableArray arrayWithArray:@[@"男",@"女"]];
    STPickerSingle *pickerSingle = [[STPickerSingle alloc]init];
    //设置默认选中的按钮
    pickerSingle.buttonRight.selected = YES;
    /** 2.边线,选择器和上方tool之间的边线 */
    pickerSingle.lineView = [[UIView alloc]init];
    //设置按钮边框颜色
    pickerSingle.borderButtonColor = [UIColor whiteColor];
    //设置数据源
    [pickerSingle setArrayData:dataM];
    //设置弹出视图的标题
    [pickerSingle setTitle:@"请选择"];
    //设置视图的位置为屏幕下方
    [pickerSingle setContentMode:STPickerContentModeBottom];
    [pickerSingle setDelegate:self];
    [pickerSingle show];
    
}
#pragma mark - STPickerSingleDelegate

- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    //    NSLog(@"选中的性别是------%@",selectedTitle);
    //    self.userModel.Data.Sex = selectedTitle;
    self.userModel.Data.Sex = [selectedTitle isEqualToString:@"男"] ? @"1" : @"0";;
    [self requestChangeUserInfo];
    
}

#pragma mark - EditPersonInfoControllerDelegate

- (void)editPersonalInfoControllerDoneButtonDidClick:(NSString *)content editType:(EditType)editType{
    
    switch (editType) {
        case kEditUserName:          //昵称
            self.userModel.Data.UserName = content;
            break;
        case kEditPastHistory:       //已往病史
            self.userModel.Data.Anamnese = content;
            break;
        case kEditAllergyHistory:    //过敏病史
            self.userModel.Data.Allergies = content;
            break;
        case kEditHereditaryDisease:  //遗传病史
            self.userModel.Data.GeneticDisease = content;
            break;
        case kEditSignature:           //签名
            self.userModel.Data.Signature = content;
            break;
        default:
            break;
    }
    
    //发送网络请求，提交数据
    [self requestChangeUserInfo];
    
}

#pragma mark - NET
#pragma mark - 获取个人信息请求
- (void)requestGetPersonInfoList
{
    
    [HTTPTool requestWithURLString:@"/api/Patient/Info" parameters:nil type:kGET success:^(id responseObject) {
        
        self.userModel = [BATPerson mj_objectWithKeyValues:responseObject];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 更新头像
- (void)requestChangePersonHeadIcon:(UIImage *)img {
    
    WeakSelf
    [HTTPTool requestUploadImageToBATWithParams:nil constructingBodyWithBlock:^(XMRequest *request) {
        
        UIImage * compressImg  = [Tools compressImageWithImage:img ScalePercent:0.001];
        NSData *imageData = UIImagePNGRepresentation(compressImg);
        [request addFormDataWithName:[NSString stringWithFormat:@"person_headicon"]
                            fileName:[NSString stringWithFormat:@"person_headicon.jpg"]
                            mimeType:@"multipart/form-data"
                            fileData:imageData];
    } success:^(NSArray *imageArray) {
        
        [weakSelf showSuccessWithText:@"上传头像成功"];
        
        NSMutableArray *imageModelArray = [BATImage mj_objectArrayWithKeyValuesArray:imageArray];
        BATImage *imageModel = [imageModelArray firstObject];
        weakSelf.userModel.Data.PhotoPath = imageModel.url;
        [weakSelf requestChangeUserInfo];
    } failure:^(NSError *error) {
        
        [weakSelf showErrorWithText:@"上传失败"];
        
    } fractionCompleted:^(double count) {
        
        [weakSelf showProgres:count];
        
    }];
}
#pragma mark - 更新个人信息
- (void)requestChangeUserInfo
{
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"ID"] = @(self.userModel.Data.AccountID);
    dictM[@"UserName"] = self.userModel.Data.UserName;
    dictM[@"PhotoPath"] = self.userModel.Data.PhotoPath;
    dictM[@"Sex"] = self.userModel.Data.Sex;
    dictM[@"Signature"] = self.userModel.Data.Signature;
    dictM[@"GeneticDisease"] = self.userModel.Data.GeneticDisease;  //家族遗传病
    dictM[@"Allergies"] = self.userModel.Data.Allergies;    //过敏史
    dictM[@"Anamnese"] = self.userModel.Data.Anamnese;     //已往病史
    
    
    [HTTPTool requestWithURLString:@"/api/Patient/Info" parameters:dictM type:kPOST success:^(id responseObject) {
        
        [self.tableView reloadData];
        
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [[info objectForKey:UIImagePickerControllerEditedImage] copy];
    
    [self requestChangePersonHeadIcon:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 弹出照片选择器

- (void)showAlertAction{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"头像选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getPhotosFromCamera];
    }];
    
    UIAlertAction *photoAlbum = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getPhotosFromLocal];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:cameraAction];
    [alertController addAction:photoAlbum];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
#pragma mark - 从本地相册获取图片
- (void)getPhotosFromLocal
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark - 拍照
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


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        [_tableView registerClass:[BATPersonalInfoTextCell class] forCellReuseIdentifier:NSStringFromClass([BATPersonalInfoTextCell class])];
        [_tableView registerClass:[BATPersonalInfoImageCell class] forCellReuseIdentifier:NSStringFromClass([BATPersonalInfoImageCell class])];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
