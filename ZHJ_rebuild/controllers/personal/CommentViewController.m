//
//  CommentViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/23.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "CommentViewController.h"

//views

//controllers
#import <TZImagePickerController.h>

//cells
#import "AddCommentTableViewCell.h"
#import "AddCommentReleaseCell.h"

//tools
#import "UIImage+Orientation.h"

//models
#import "OrderList_OrderListModel.h"
#import "OrderListGoodsModel.h"


#define kCellReleaseID @"CellReleaseID"

@interface CommentViewController ()<TZImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)UIImagePickerController *pickerCamara;
@property (nonatomic, strong)TZImagePickerController *pickerAlbum;

//@property (nonatomic, strong)NSArray *goodsArray;
@property (nonatomic, assign)NSInteger indexPath_row;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self settingAbout];
    [self settingTableView];
    
    [self respondWithRACCommentVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <懒加载>
//-(NSMutableArray *)imagesArray
//{
//    if (!_imagesArray) {
//        _imagesArray = [[NSMutableArray alloc]init];
//    }
//    return _imagesArray;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma  mark - <相关设置>
-(void)settingAbout
{
//    self.goodsArray = self.modelOrderList.goods;
    
    self.modelOrderList;
}

#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nibComment = [UINib nibWithNibName:NSStringFromClass([AddCommentTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibComment forCellReuseIdentifier:NSStringFromClass([AddCommentTableViewCell class])];
    
    UINib *nibRelease = [UINib nibWithNibName:NSStringFromClass([AddCommentReleaseCell class]) bundle:nil];
    [self.tableView registerNib:nibRelease forCellReuseIdentifier:NSStringFromClass([AddCommentReleaseCell class])];
}

#pragma mark - <请求发布评论数据>
-(void)getAddCommentData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kAddComment];
    
}

#pragma mark - <发布评论>
-(void)releaseMyComment
{
    //遍历
}


#pragma mark - <调起相机／相册提示框>
-(void)callCameraOrAblumWithIndexPath_row:(NSInteger)indexPath_row
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:@"优雅自拍" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectCamaraPickerWithIndexPath_row:indexPath_row];
    }];
    UIAlertAction *actionAlbum = [UIAlertAction actionWithTitle:@"浏览相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectAlbumPickerWithIndexPath_row:indexPath_row];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:actionCamera];
    [alertVC addAction:actionAlbum];
    [alertVC addAction:actionCancel];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - <调起相机>
-(void)selectCamaraPickerWithIndexPath_row:(NSInteger)indexPath_row
{
    self.pickerCamara = [[UIImagePickerController alloc]init];
    //判断系统是否允许选择相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // 设置图片来源是相机
        self.pickerCamara.sourceType = UIImagePickerControllerSourceTypeCamera;
        //设置代理
        self.pickerCamara.delegate = self;
        //模态显示界面
        [self presentViewController:self.pickerCamara animated:YES completion:nil];
    }else{
        NSLog(@"不支持相机");
    }
}

#pragma mark - <调起相册>
-(void)selectAlbumPickerWithIndexPath_row:(NSInteger)indexPath_row
{
    OrderListGoodsModel *model = self.modelOrderList.goods[indexPath_row];
    self.pickerAlbum = [[TZImagePickerController alloc] initWithMaxImagesCount:(4-model.pickerImageArray.count) delegate:self];
    //不允许用户选择原图
    self.pickerAlbum.allowPickingOriginalPhoto = NO;
    [self presentViewController:self.pickerAlbum animated:YES completion:nil];
}

#pragma mark - <rac响应>
-(void)respondWithRACCommentVC
{
    //调起相机或相册
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"callCameraOrAblum" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSNumber *tag = x.object;
        self.indexPath_row = [tag integerValue];
        [self callCameraOrAblumWithIndexPath_row:self.indexPath_row];
    }];
    
    //删除已选图片
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"deleteImageFromAddComment" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSDictionary *dict = x.object;
        NSInteger goods_row = [dict[@"goods_row"] integerValue];
        NSInteger image_item = [dict[@"image_item"] integerValue];
        NSLog(@"大傻逼");
        
        OrderListGoodsModel *modelGood = self.modelOrderList.goods[goods_row];
        [modelGood.pickerImageArray removeObjectAtIndex:image_item];
        [self.tableView reloadData];
    }];
}















#pragma mark - **** UITableViewDelegate,UITableViewDataSource ****
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelOrderList.goods.count+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.modelOrderList.goods.count) {
        return 60;
    }else{
        return 350;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.modelOrderList.goods.count) {
        AddCommentReleaseCell *cellRelease = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AddCommentReleaseCell class])];
        return cellRelease;
    }
    
    OrderListGoodsModel *modelGoods = self.modelOrderList.goods[indexPath.row];
    AddCommentTableViewCell *cellComment = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AddCommentTableViewCell class])];
    cellComment.modelGoods = modelGoods;
    cellComment.collectionView.tag = indexPath.row;
    cellComment.modelOrderList = self.modelOrderList;
    return cellComment;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.modelOrderList.goods.count) {
        [self releaseMyComment];
    }
}



#pragma mark - ** TZImagePickerControllerDelegate ***
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    OrderListGoodsModel *model = self.modelOrderList.goods[self.indexPath_row];
    //初始化model.pickerImageArray
    if (!model.pickerImageArray) {
        model.pickerImageArray = [NSMutableArray array];
    }
    if (picker == self.pickerAlbum) {
        NSMutableArray *photosArray = [photos mutableCopy];
        if (photosArray.count > 0) {
            for (UIImage  *image in photosArray) {
                [model.pickerImageArray addObject:image];
            }
        }
        [self.tableView reloadData];
    }
    
}

#pragma mark - *** UIImagePickerControllerDelegate ****
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0)
{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //通过key值获取相片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    if (picker == self.pickerCamara) {
        //判断数据源类型
        if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        OrderListGoodsModel *model = self.modelOrderList.goods[self.indexPath_row];
        //把按钮中的图片转化成NSData，用于判断改图片是否存在
        UIImage *imgMain = [UIImage fixOrientation:image];
        
        //初始化model.pickerImageArray
        if (!model.pickerImageArray) {
            model.pickerImageArray = [NSMutableArray array];
        }
        [model.pickerImageArray addObject:imgMain];
        [self.tableView reloadData];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}





@end
