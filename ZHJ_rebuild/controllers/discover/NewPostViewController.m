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

//models
#import "MyJoinedCircleResultModel.h"

@interface NewPostViewController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForScrollView;

@property (weak, nonatomic) IBOutlet UILabel *labelCircle;
@property (weak, nonatomic) IBOutlet UITextView *feedbackView;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;
@property (weak, nonatomic) IBOutlet UILabel *labelTopic;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(nonatomic, strong)NSMutableArray *imagesArray;

//发布帖子所属圈子
@property (nonatomic, strong)NSString *circle_id;
@property (nonatomic, strong)NSString *topic_id;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingOutlets];
    [self settingCollectionView];
    
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

#pragma mark - <配置outlets>
-(void)settingOutlets
{
    self.feedbackView.delegate = self;
    self.placeholder.userInteractionEnabled = NO;
}

#pragma mark - <选择发新帖所属的圈子>
- (IBAction)btnSelectCycleAction:(UIButton *)sender
{
    MoreCycleViewController *moreCycleVC = [[MoreCycleViewController alloc]initWithNibName:NSStringFromClass([MoreCycleViewController class]) bundle:nil];
    moreCycleVC.moreType = @"moreJoined";
    moreCycleVC.whereReuseFrom = @"newPostVC";
    moreCycleVC.hidesBottomBarWhenPushed = NO;
    [self.navigationController pushViewController:moreCycleVC animated:YES];
}

#pragma mark - <显示位置>
- (IBAction)btnDisplayPosition:(id)sender
{
    
}

#pragma mark - <选择话题>
- (IBAction)btnSelectTopic:(UIButton *)sender
{
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
    AtSomeOneViewController *atSomeOneVC = [[AtSomeOneViewController alloc]initWithNibName:NSStringFromClass([AtSomeOneViewController class]) bundle:nil];
    atSomeOneVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:atSomeOneVC animated:YES];
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

#pragma mark - <跳转“选择话题”>
-(void)jumpToSelectTopicVCWithCircleID:(NSString *)circle_id
{
    SelectTopicViewController *selectTopicVC = [[SelectTopicViewController alloc]initWithNibName:NSStringFromClass([SelectTopicViewController class]) bundle:nil];
    selectTopicVC.circle_id = circle_id;
    [self.navigationController pushViewController:selectTopicVC animated:YES];
}

#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    //删除已选图片
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"deleteImage" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
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
    }];
    
    //选择话题
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"selectTopic" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSDictionary *dict = x.object;
        self.topic_id = dict[@"topic_id"];
        self.labelTopic.text = [NSString stringWithFormat:@"#%@#",dict[@"topic_title"]];
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
    if (self.imagesArray.count < 9) {
        return self.imagesArray.count+1;
    }
    return self.imagesArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [[UICollectionViewCell alloc]init];
    
    if (self.imagesArray.count == indexPath.row) {
        UICollectionViewCell *cellNormal = [collectionView dequeueReusableCellWithReuseIdentifier:@"selectImageNormal" forIndexPath:indexPath];
        cellNormal.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jia"]];
        cell = cellNormal;
    }else{
        NewPostImageCell *cellImage = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NewPostImageCell class]) forIndexPath:indexPath];
        cellImage.imgView.image = self.imagesArray[indexPath.row];
        cellImage.btnDeleteImage.tag = indexPath.row;
        cell = cellImage;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.imagesArray.count < 9) {
        if (indexPath.row == (self.imagesArray.count)) {
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(9-self.imagesArray.count) delegate:self];
            //不允许用户选择原图
            imagePickerVc.allowPickingOriginalPhoto = NO;
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}

#pragma mark - ** TZImagePickerControllerDelegate ***
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    NSMutableArray *photosArray = [photos mutableCopy];
    if (self.imagesArray.count == 0) {
        self.imagesArray = photosArray;
    }else{
        for (UIImage  *image in photosArray) {
            [self.imagesArray addObject:image];
        }
    }
    [self.collectionView reloadData];
}





@end
