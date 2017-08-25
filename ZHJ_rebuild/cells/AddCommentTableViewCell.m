//
//  AddCommentTableViewCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/23.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "AddCommentTableViewCell.h"

//views
#import "RatingBar.h"
#import "SSCheckBoxView.h"

//controllers
#import <TZImagePickerController.h>

//cells
#import "NewPostImageCell.h"

//tools
#import "UIImage+Orientation.h"

@interface AddCommentTableViewCell ()<UITextViewDelegate,RatingDelegate,UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong)UIImagePickerController *pickerCamara;
@property (nonatomic, strong)TZImagePickerController *pickerAlbum;
@property (nonatomic, strong)NSMutableArray *imagesArray;
@property (nonatomic, strong)NSArray *goodsArray;

@end

@implementation AddCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self respondWithRAC];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)drawRect:(CGRect)rect
{
    [self settingOutlets];
    
}

-(NSMutableArray *)imagesArray
{
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}

#pragma mark - <配置outlets>
-(void)settingOutlets
{
    //ratingBar
    self.starBar = [[RatingBar alloc]initWithFrame:self.starBGView.bounds];
    [self.starBGView addSubview:self.starBar];
    self.starBar.enable = YES;
    self.starBar.delegate = self;
    self.starBar.starNumber = 5;
    self.goods_grade = 5;
    
    //tvCommentContent
    self.tvCommentContent.delegate = self;
    
    //checkBox
    self.checkBox = [[SSCheckBoxView alloc]initWithFrame:self.checkBoxBGView.bounds style:kSSCheckBoxViewStyleGreen checked:NO];
    
    self.is_anonymous = @"0";
    [self.checkBoxBGView addSubview:self.checkBox];
    
    __weak typeof(self) weakSelf = self;
    self.checkBox.stateChangedBlock = ^(SSCheckBoxView *cbv) {
        if (cbv.checked) {
            weakSelf.is_anonymous = @"1";
        }else{
            weakSelf.is_anonymous = @"0";
        }
    };
    
    //collectionView
    [self settingCollectionView];
}

#pragma mark - <配置collectionView>
-(void)settingCollectionView
{
    CGFloat itemWidth = (kSCREEN_WIDTH-20)/4.4;
    CGFloat itemHeight = itemWidth;
    self.flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([NewPostImageCell class]) bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([NewPostImageCell class])];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"selectImageNormal"];
}

-(void)setModelGoods:(OrderListGoodsModel *)modelGoods
{
    _modelGoods = modelGoods;
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelGoods.image];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgProduct sd_setImageWithURL:url placeholderImage:kPlaceholder];
    
    self.imagesArray = modelGoods.pickerImageArray;
    [self.collectionView reloadData];
}

-(void)setModelOrderList:(OrderList_OrderListModel *)modelOrderList
{
    _modelOrderList = modelOrderList;
    self.goodsArray = modelOrderList.goods;
    [self.collectionView reloadData];
}

#pragma mark - <rac响应>
-(void)respondWithRAC
{
    
}








#pragma mark - ***** RatingDelegate ****
-(void)setRating:(NSInteger)rating isHuman:(BOOL)isHuman
{
    switch (rating) {
        case 0:{
            self.labelStatus.text = @"非常差";
            self.starBar.starNumber = 1;
            self.goods_grade = 1;
        }
            break;
        case 1:{
            self.labelStatus.text = @"非常差";
            //            self.starBar.starNumber = 1;
        }
            break;
        case 2:{
            self.labelStatus.text = @"比较差";
            //            self.starBar.starNumber = 2;
        }
            break;
        case 3:{
            self.labelStatus.text = @"一般";
            //            self.starBar.starNumber = 3;
        }
            break;
        case 4:{
            self.labelStatus.text = @"较满意";
            //            self.starBar.starNumber = 4;
        }
            break;
        case 5:{
            self.labelStatus.text = @"非常满意";
            //            self.starBar.starNumber = 5;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - ***** UITextViewDelegate ******
-(void)textViewDidChange:(UITextView *)textView
{
    self.placeholder.hidden = YES;
    if (textView.text.length == 0) {
        self.placeholder.hidden = NO;
    }
}


#pragma mark - **** UICollectionViewDelegate,UICollectionViewDataSource ****
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    NSArray *goodsArray = self.modelGoods.pickerImageArray;
    if (self.imagesArray.count < 4) {
        return self.imagesArray.count+1;
    }
    return self.imagesArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [[UICollectionViewCell alloc]init];
    
    if (self.imagesArray.count == indexPath.row) {
        UICollectionViewCell *cellNormal = [collectionView dequeueReusableCellWithReuseIdentifier:@"selectImageNormal" forIndexPath:indexPath];
        cellNormal.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addPhoto"]];
        cell = cellNormal;
    }else{
        NewPostImageCell *cellImage = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NewPostImageCell class]) forIndexPath:indexPath];
        cellImage.imgView.image = self.imagesArray[indexPath.row];
        
        cellImage.fromWhere = @"addComment";
        cellImage.tag = self.collectionView.tag;
        //用于标记cellImage属于collectionView所在的item
        cellImage.btnDeleteImage.tag = indexPath.row;
        cell = cellImage;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *tag = [NSNumber numberWithInteger:self.collectionView.tag];
    if (self.imagesArray.count < 4) {
        if (indexPath.row == (self.imagesArray.count)) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"callCameraOrAblum" object:tag];
        }
    }
}





@end
