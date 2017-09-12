//
//  ProductColorAndCountView.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/24.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "BuyNowSelectSpecView.h"

//cells
#import "ProductStyleSelectionCell.h"

//tools
#import "CALayer+XIBUIColor.h"
#import "NSString+ContentWidth.h"

//views
#import "ProductDetailSpecHeaderView.h"

//models
#import "GoodsDetailSpec_ListModel.h"
#import "GoodsDetailSpec_ValueModel.h"
#import "GetSpecPriceModel.h"
#import "AddToCartModel.h"

@interface BuyNowSelectSpecView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)NSMutableArray *specValueArray;
//用于保存一份self.dataarray;用作修改
@property (nonatomic, strong)NSMutableArray *tempArray;

@end

@implementation BuyNowSelectSpecView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self settingCountBGView];
    [self settingFlowLayout];
    [self settingCollectionView];
}

#pragma mark - <懒加载>
-(NSMutableArray *)specValueArray
{
    if (!_specValueArray) {
        _specValueArray = [NSMutableArray array];
    }
    return _specValueArray;
}
-(NSMutableArray *)tempArray
{
    if (!_tempArray) {
        _tempArray = [NSMutableArray array];
    }
    return _tempArray;
}

-(void)setDefaultPrice:(NSString *)defaultPrice
{
    self.labelPrice.text = [NSString stringWithFormat:@"¥ %@",defaultPrice];
}

-(void)setGoods_code:(NSString *)goods_code
{
    self.labelProductCode.text = [NSString stringWithFormat:@"商品编号:%@",goods_code];
}

-(void)settingCountBGView
{
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.countBGView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(3, 3)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.lineWidth = 0.5;
    maskLayer1.strokeColor = [UIColor blackColor].CGColor;
    maskLayer1.fillColor = nil;
    maskLayer1.frame = self.countBGView.bounds;
    maskLayer1.path = maskPath1.CGPath;
    [self.countBGView.layer addSublayer:maskLayer1];
}

-(void)settingFlowLayout
{
    CGFloat itemWidth = 100;
    CGFloat itemHeight = 30;
    //    self.flowLayout.estimatedItemSize = CGSizeMake(itemWidth, itemHeight);
    //    self.flowLayout.itemSize = uicoll
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 0, 0);
    
    self.flowLayout.headerReferenceSize = CGSizeMake(itemWidth, itemHeight);
}

-(void)settingCollectionView
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.allowsMultipleSelection = YES;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([ProductStyleSelectionCell class]) bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([ProductStyleSelectionCell class])];
    
    [self.collectionView registerClass:[ProductDetailSpecHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"specHeader"];
}

-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    self.tempArray = [NSMutableArray arrayWithArray:dataArray];
    //        GoodsDetailSpec_ListModel *model = self.tempArray[0];
    //        model.selectedId = @"2";
    [self.collectionView reloadData];
    for (int i=0; i<self.tempArray.count; i++) {
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:i] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    
    for ( GoodsDetailSpec_ListModel *modelSpecList in self.tempArray) {
        GoodsDetailSpec_ValueModel *modelSpecValue = modelSpecList.spec_value[0];
        modelSpecList.selectedId = modelSpecValue.item_id;
        [self.specValueArray addObject:modelSpecList.selectedId];
    }
//    NSDictionary *dictParameter = @{@"spec_item_id":self.specValueArray,
//                                    @"goods_id":self.goods_id};
//    [self getSpecPriceDataWith:dictParameter];
    
    
    //设置默认数据
    if (_dataArray.count > 0) {
        GoodsDetailSpec_ListModel *modelSpecList = _dataArray[0];
        GoodsDetailSpec_ValueModel *modelSpecValue = modelSpecList.spec_value[0];
        
        NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelSpecValue.src];
        NSURL *url = [NSURL URLWithString:imgStr];
        [self.imgProduct sd_setImageWithURL:url placeholderImage:kPlaceholder];
    }
    
}

#pragma mark - <获取商品规格对应的实际价格>
-(void)getSpecPriceDataWith:(NSDictionary *)param
{
    NSString *str = [NSString stringWithFormat:@"%@%@",kDomainBase,kGetSpecPrice];
    
    [YQNetworking postWithUrl:str refreshRequest:YES cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            GetSpecPriceModel *modelSpecPrice = [[GetSpecPriceModel alloc]initWithDictionary:dataDict error:nil];
            self.labelPrice.text = [NSString stringWithFormat:@"¥ %@",modelSpecPrice.data.result.price];
        }
    } failBlock:nil];
}

- (IBAction)btnCancelAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"removeBuyNowSpecView" object:nil];
}

- (IBAction)btnIncreaseAction:(UIButton *)sender
{
    int count = [self.labelCount.text intValue];
    if (count >= 1) {
        count++;
    }
    self.labelCount.text = [NSString stringWithFormat:@"%d",count];
}

- (IBAction)btnDecreaseAction:(UIButton *)sender
{
    int count = [self.labelCount.text intValue];
    if (count > 1) {
        count--;
    }
    self.labelCount.text = [NSString stringWithFormat:@"%d",count];
}

#pragma mark - <立即提交>
- (IBAction)btnSubmitAndRequest:(UIButton *)sender
{
    [self btnCancelAction:nil];
    
    if (self.goods_id && self.labelCount.text && self.specValueArray.count>0 && kUserDefaultObject(kUserInfo)) {
        NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                        @"goods_id":self.goods_id,
                                        @"goods_num":self.labelCount.text,
                                        @"goods_spec":self.specValueArray};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"jumpToOrderConfirmVC" object:dictParameter];
    }
}

#pragma mark - <请求加入购物车>
-(void)GetAddToCartData
{
    NSString *str = [NSString stringWithFormat:@"%@%@",kDomainBase,kAddToCart];
    
    NSDictionary *dictParameter = [NSDictionary dictionary];
    if (![self.goods_id isEqualToString:@""] || ![self.labelCount.text isEqualToString:@""] || kUserDefaultObject(kUserInfo) || self.specValueArray.count>0) {
        NSString *userID = kUserDefaultObject(kUserInfo);
        dictParameter = @{@"goods_id":self.goods_id,
                          @"goods_num":self.labelCount.text,
                          @"user_id":userID,
                          @"goods_spec":self.specValueArray};
    }
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self animated:YES];
    
    [YQNetworking postWithUrl:str refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        [hud hideAnimated:YES afterDelay:1.0];
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            AddToCartModel *model = [[AddToCartModel alloc]initWithDictionary:dataDict error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self animated:YES warningMessage:model.msg];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            });
            
            
            //发送通知刷新购物车页面
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshCartList" object:nil];
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        });
    }];
    
}


#pragma mark - <重新设置选中规格>
-(void)settingSelectedSpecItemWith:(NSIndexPath *)indexPath
{
    for (int i=0; i<self.tempArray.count; i++) {
        if (i == indexPath.section) {
            GoodsDetailSpec_ListModel *modelSpecList = self.tempArray[i];
            
            for (int j = 0; j<modelSpecList.spec_value.count; j++) {
                if (j != indexPath.item) {
                    NSIndexPath *indePath_deSelect = [NSIndexPath indexPathForItem:j inSection:i];
                    [self.collectionView deselectItemAtIndexPath:indePath_deSelect animated:YES];
                }
            }
        }
    }
}











#pragma mark - **** UICollectionViewDelegate,UICollectionViewDataSource *****
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArray.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    GoodsDetailSpec_ListModel *modelSpecList = self.dataArray[section];
    NSArray *specValueArray = modelSpecList.spec_value;
    return specValueArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailSpec_ListModel *modelSpecList = self.dataArray[indexPath.section];
    NSArray *specValueArray = modelSpecList.spec_value;
    GoodsDetailSpec_ValueModel *modelSpecValue = specValueArray[indexPath.item];
    
    ProductStyleSelectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ProductStyleSelectionCell class]) forIndexPath:indexPath];
    [cell.btnStyleName setTitle:modelSpecValue.item forState:UIControlStateNormal];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [[UICollectionReusableView alloc]init];
    GoodsDetailSpec_ListModel *modelSpecList = self.dataArray[indexPath.section];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ProductDetailSpecHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"specHeader" forIndexPath:indexPath];
        headerView.name = modelSpecList.spec_name;
        view = headerView;
    }
    return view;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailSpec_ListModel *modelSpecList = self.tempArray[indexPath.section];
    GoodsDetailSpec_ValueModel *modelSpecValue = modelSpecList.spec_value[indexPath.row];
    modelSpecList.selectedId = modelSpecValue.item_id;
    
    if (![modelSpecValue.src isEqualToString:@""]) {
        NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelSpecValue.src];
        NSURL *url = [NSURL URLWithString:imgStr];
        [self.imgProduct sd_setImageWithURL:url placeholderImage:kPlaceholder];
    }
    //重新设置item选中
    [self settingSelectedSpecItemWith:indexPath];
    //上传选中的item_id获取实际价格
    [self.specValueArray removeAllObjects];
    for ( GoodsDetailSpec_ListModel *modelSpecList in self.tempArray) {
        [self.specValueArray addObject:modelSpecList.selectedId];
    }
    
    //修改“已选规格”
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeSelectedSpec" object:self.specValueArray];
    
    NSDictionary *dictParameter = @{@"spec_item_id":self.specValueArray,
                                    @"goods_id":self.goods_id};
    [self getSpecPriceDataWith:dictParameter];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailSpec_ListModel *modelSpecList = self.dataArray[indexPath.section];
    NSArray *specValueArray = modelSpecList.spec_value;
    GoodsDetailSpec_ValueModel *modelSpecValue = specValueArray[indexPath.item];
    CGFloat width = [NSString getWidthWithContent:modelSpecValue.item font:13 contentSize:CGSizeMake(kSCREEN_WIDTH, 30)];
    
    return CGSizeMake(width+30, 30);
}



@end
