//
//  NewPostViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "NewPostViewController.h"

//controller
#import <TZImagePickerController.h>
#import "MoreCycleViewController.h"
#import "AtSomeOneViewController.h"
#import "SelectTopicViewController.h"

//cells
#import "NewPostImageCell.h"
#import "ProductStyleSelectionCell.h"

//models
#import "MyJoinedCircleResultModel.h"

//tools
#import "NSString+ContentWidth.h"
#import <AFNetworking.h>
#import "UIImage+Orientation.h"

@interface NewPostViewController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForScrollView;

@property (weak, nonatomic) IBOutlet UILabel *labelCircle;
@property (weak, nonatomic) IBOutlet UITextView *feedbackView;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;
@property (weak, nonatomic) IBOutlet UILabel *labelTopic;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayoutAtSomeone;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewAtSomeone;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForCollectionAt;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


//发布帖子所属圈子
@property (nonatomic, strong)NSString *circle_id;
//话题
@property (nonatomic, strong)NSString *topic_id;
//@
@property (nonatomic, strong)NSArray *atUserIDArray;
//图片数组
@property(nonatomic, strong)NSMutableArray *imagesArray;
@property (nonatomic, strong)NSMutableArray *imageDataArray;

@property (nonatomic, strong)NSString *location;
@property (nonatomic, strong)NSString *longitude;
@property (nonatomic, strong)NSString *latitude;


@end

@implementation NewPostViewController


#pragma mark - <懒加载>
-(NSMutableArray *)imagesArray
{
    if (!_imagesArray) {
        _imagesArray = [[NSMutableArray alloc]init];
    }
    return _imagesArray;
}

-(NSMutableArray *)imageDataArray
{
    if (!_imageDataArray) {
        _imageDataArray = [NSMutableArray array];
    }
    return _imageDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingOutlets];
    [self settingCollectionView];
    [self settingCollectionViewAtSomeone];
    
    [self respondWithRAC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <发布新帖子>
-(void)requestPostMessageWithDictParameter:(NSDictionary *)dictParameter imgDataArray:(NSArray *)imgDataArray atUserIDs:(NSArray *)atUserArray
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kPostMessage];
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",
                                                         @"multipart/form-data",
                                                         @"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json", nil];
    [manager POST:urlStr
       parameters:dictParameter
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    
    for (int i=0; i<atUserArray.count; i++) {
        NSDictionary *dict = atUserArray[i];
        NSString *at_user_id = dict[@"user_id"];
        NSData *data = [at_user_id dataUsingEncoding:NSUTF8StringEncoding];
        NSString *name = [NSString stringWithFormat:@"at_user_ids[%d]",i];
        [formData appendPartWithFormData:data name:name];
    }
    
    for (int i=0; i<imgDataArray.count; i++) {
        NSData *dataImg = imgDataArray[i];
        NSString *name = [NSString stringWithFormat:@"images[%d]",i];
        NSString *fileName = [NSString stringWithFormat:@"image%d.jpg",i];
        [formData appendPartWithFileData:dataImg name:name fileName:fileName mimeType:@"image/jpeg"];
    }
}
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if (responseObject) {
                  NSDictionary *dataDict = (NSDictionary *)responseObject;
                  NSNumber *code = (NSNumber *)dataDict[@"code"];
                  if ([code isEqual:@200]) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [hud hideAnimated:YES afterDelay:1.0];
                          MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                          [hudWarning hideAnimated:YES afterDelay:2.0];
                          hudWarning.completionBlock = ^{
                              [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshMyDomainVCAfterPostMessage" object:nil];
                              [self.navigationController popViewControllerAnimated:YES];
                          };
                      });
                  }else{
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [hud hideAnimated:YES afterDelay:1.0];
                          MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                          [hudWarning hideAnimated:YES afterDelay:2.0];
                      });
                  }
              }else{
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [hud hideAnimated:YES afterDelay:1.0];
                      MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                      [hudWarning hideAnimated:YES afterDelay:2.0];
                  });
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              dispatch_async(dispatch_get_main_queue(), ^{
                  [hud hideAnimated:YES afterDelay:1.0];
                  MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                  [hudWarning hideAnimated:YES afterDelay:2.0];
              });
          }];
}

#pragma mark - <配置outlets>
-(void)settingOutlets
{
    self.feedbackView.delegate = self;
    self.placeholder.userInteractionEnabled = NO;
    
    UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.frame = CGRectMake(0, 0, 35, 35);
    [btnSearch setTitle:@"发布" forState:UIControlStateNormal];
    [btnSearch setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnSearch.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnSearch addTarget:self action:@selector(btnPostAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtnSearch = [[UIBarButtonItem alloc]initWithCustomView:btnSearch];
    self.navigationItem.rightBarButtonItem = barBtnSearch;
}

#pragma mark - <发布按钮响应>
-(void)btnPostAction:(UIButton *)sender
{
    NSMutableDictionary *dictParameter = [NSMutableDictionary dictionary];
    
    //topic_id
    if (self.topic_id) {
        [dictParameter setObject:self.topic_id forKey:@"topic_id"];
    }
    
    //circle_id
    if (self.circle_id) {
        [dictParameter setObject:self.circle_id forKey:@"circle_id"];
    }
    
    //location
    if (self.location) {
        [dictParameter setObject:self.location forKey:@"location"];
    }
    
    //longitude
    if (self.longitude) {
        [dictParameter setObject:self.longitude forKey:@"longitude"];
    }
    
    //latitude
    if (self.latitude) {
        [dictParameter setObject:self.latitude forKey:@"latitude"];
    }
    
    //content
    if (![self.feedbackView.text isEqualToString:@""]) {
        [dictParameter setObject:self.feedbackView.text forKey:@"content"];
    }
    
    //at_user_ids
    //images
    
    //content
    if (!kUserDefaultObject(kUserInfo)){
        
    }else{
        //user_id
        [dictParameter setObject:kUserDefaultObject(kUserInfo) forKey:@"user_id"];
        [self requestPostMessageWithDictParameter:dictParameter imgDataArray:self.imageDataArray atUserIDs:self.atUserIDArray];
    }
    
    
    
}


#pragma mark - <选择发新帖所属的圈子>
- (IBAction)btnSelectCycleAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    [self jumpToMyCircleVCWithMoreType:@"moreJoined" whereReuseFrom:@"newPostVC"];
}

#pragma mark - <显示位置>
- (IBAction)btnDisplayPosition:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark - <选择话题>
- (IBAction)btnSelectTopic:(UIButton *)sender
{
    [self.view endEditing:YES];
    if (self.circle_id) {
        [self jumpToSelectTopicVCWithCircleID:self.circle_id];
    }else{
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请选择圈子"];
        [hudWarning hideAnimated:YES afterDelay:2.0];
    }
    
}

#pragma mark - <@某人>
- (IBAction)btnAtSomeOneAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    [self jumpToAtSomeoneVC];
}

#pragma mark - <配置collectionView>
-(void)settingCollectionView
{
    CGFloat itemWidth = (kSCREEN_WIDTH-20)/3.3;
    CGFloat itemHeight = itemWidth;
    self.flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([NewPostImageCell class]) bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([NewPostImageCell class])];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"selectImageNormal"];
}

#pragma mark - <配置collectionViewAtSomeone>
-(void)settingCollectionViewAtSomeone
{
    self.flowLayoutAtSomeone.minimumInteritemSpacing = 5;
    self.flowLayoutAtSomeone.minimumLineSpacing = 2;
    self.flowLayoutAtSomeone.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    self.collectionViewAtSomeone.delegate = self;
    self.collectionViewAtSomeone.dataSource = self;
    self.collectionViewAtSomeone.scrollEnabled = NO;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([ProductStyleSelectionCell class]) bundle:nil];
    [self.collectionViewAtSomeone registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([ProductStyleSelectionCell class])];
}

#pragma mark - <跳转“选择话题”>
-(void)jumpToSelectTopicVCWithCircleID:(NSString *)circle_id
{
    SelectTopicViewController *selectTopicVC = [[SelectTopicViewController alloc]initWithNibName:NSStringFromClass([SelectTopicViewController class]) bundle:nil];
    selectTopicVC.circle_id = circle_id;
    [self.navigationController pushViewController:selectTopicVC animated:YES];
}

#pragma mark - <跳转“at好友”>
-(void)jumpToAtSomeoneVC
{
    AtSomeOneViewController *atSomeOneVC = [[AtSomeOneViewController alloc]initWithNibName:NSStringFromClass([AtSomeOneViewController class]) bundle:nil];
    atSomeOneVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:atSomeOneVC animated:YES];
}

#pragma mark - <跳转“所属圈子”>
-(void)jumpToMyCircleVCWithMoreType:(NSString *)moreType whereReuseFrom:(NSString *)whereReuseFrom
{
    MoreCycleViewController *moreCycleVC = [[MoreCycleViewController alloc]initWithNibName:NSStringFromClass([MoreCycleViewController class]) bundle:nil];
    moreCycleVC.moreType = moreType;
    moreCycleVC.whereReuseFrom = whereReuseFrom;
    moreCycleVC.hidesBottomBarWhenPushed = NO;
    [self.navigationController pushViewController:moreCycleVC animated:YES];
}

#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    //删除已选图片
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"deleteImageFromNewPost" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        UIButton *button = x.object;
        NSUInteger tag =  button.tag;
        if (self.imagesArray.count > tag) {
            [self.imagesArray removeObjectAtIndex:tag];
        }
        
        [self.collectionView reloadData];
    }];
    
    //选择所属圈子
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"selectedCircleForNewPost" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        MyJoinedCircleResultModel *model = x.object;
        self.labelCircle.text = model.circle_name;
        self.circle_id = model.circle_id;
        
        //清空话题内容
        self.labelTopic.text = @"";
        self.topic_id = nil;
    }];
    
    //选择话题
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"selectTopic" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSDictionary *dict = x.object;
        self.topic_id = dict[@"topic_id"];
        self.labelTopic.text = [NSString stringWithFormat:@"#%@#",dict[@"topic_title"]];
    }];
    
    //选择@ren
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"selectAtFriend" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        self.atUserIDArray = x.object;
        [self.collectionViewAtSomeone reloadData];

        self.heightForCollectionAt.constant = self.flowLayoutAtSomeone.collectionViewContentSize.height;
        
        //确定页面高度
        self.heightForScrollView.constant = kSCREEN_WIDTH+self.heightForCollectionAt.constant+240;
    }];
}










#pragma mark - ***** UITextViewDelegate ******
- (void)textViewDidChange:(UITextView *)textView
{
    self.placeholder.hidden = YES;
    //允许提交按钮点击操作
    //    self.commitButton.backgroundColor = FDMainColor;
    //    self.commitButton.userInteractionEnabled = YES;
    //实时显示字数
    self.limitLabel.text = [NSString stringWithFormat:@"%lu/300", (unsigned long)textView.text.length];
    
    //字数限制操作
    if (textView.text.length >= 300) {
        
        textView.text = [textView.text substringToIndex:300];
        self.limitLabel.text = @"300/300";
        
    }
    //取消按钮点击权限，并显示提示文字
    if (textView.text.length == 0) {
        
        self.placeholder.hidden = NO;
        //        self.commitButton.userInteractionEnabled = NO;
        //        self.commitButton.backgroundColor = [UIColor lightGrayColor];
    }
}



#pragma mark - *** UICollectionViewDelegate,UICollectionViewDataSource ****
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (collectionView == self.collectionView) {
        if (self.imagesArray.count < 9) {
            count = self.imagesArray.count+1;
        }else{
            count = self.imagesArray.count;
        }
    }
    
    if (collectionView == self.collectionViewAtSomeone){
        count = self.atUserIDArray.count;
    }
    
    return count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [[UICollectionViewCell alloc]init];
    if (collectionView == self.collectionView) {
        if (self.imagesArray.count == indexPath.row) {
            UICollectionViewCell *cellNormal = [collectionView dequeueReusableCellWithReuseIdentifier:@"selectImageNormal" forIndexPath:indexPath];
            cellNormal.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addPhoto"]];
            cell = cellNormal;
        }else{
            NewPostImageCell *cellImage = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NewPostImageCell class]) forIndexPath:indexPath];
            cellImage.imgView.image = self.imagesArray[indexPath.row];
            cellImage.btnDeleteImage.tag = indexPath.row;
            cellImage.fromWhere = @"newPostVC";
            cell = cellImage;
        }
    }
    
    if (collectionView == self.collectionViewAtSomeone){
        ProductStyleSelectionCell *cellAt = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ProductStyleSelectionCell class]) forIndexPath:indexPath];
        NSDictionary *dict = self.atUserIDArray[indexPath.row];
        NSString *str = [NSString stringWithFormat:@"@%@",dict[@"nickname"]];
        [cellAt.btnStyleName setTitle:str forState:UIControlStateNormal];
        cellAt.btnStyleName.backgroundColor = kColorFromRGB(kThemeYellow);
        cellAt.whereReuseFrom = @"newPost";
        cell = cellAt;
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionView) {
        if (self.imagesArray.count < 9) {
            if (indexPath.row == (self.imagesArray.count)) {
                TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(9-self.imagesArray.count) delegate:self];
                //不允许用户选择原图
                imagePickerVc.allowPickingOriginalPhoto = NO;
                [self presentViewController:imagePickerVc animated:YES completion:nil];
            }
        }
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    if (collectionView == self.collectionViewAtSomeone) {
        NSDictionary *dict = self.atUserIDArray[indexPath.row];
        NSString *str = [NSString stringWithFormat:@"@%@",dict[@"nickname"]];
        CGFloat width = [NSString getWidthWithContent:str font:13 contentSize:CGSizeMake(kSCREEN_WIDTH, 30)];
        size = CGSizeMake(width+30, 30);
    }else{
        CGFloat itemWidth = (kSCREEN_WIDTH-20)/3.3;
        CGFloat itemHeight = itemWidth;
        size = CGSizeMake(itemWidth, itemHeight);
    }
    
    
    return size;
}

#pragma mark - ** TZImagePickerControllerDelegate ***
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    NSMutableArray *photosArray = [photos mutableCopy];
    
    for (UIImage *image in photosArray) {
        [self.imagesArray addObject:image];
        
        //转化为data
        UIImage *imgDetail = [UIImage fixOrientation:image];
        NSData *dataDetailImg = UIImageJPEGRepresentation(imgDetail,0.3);
        [self.imageDataArray addObject:dataDetailImg];
    }
    [self.collectionView reloadData];
    
    
    
}





@end
