//
//  ProductDetailHeaderView.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/3.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ProductDetailHeaderView.h"

//views
#import "RatingBar.h"
#import "STPickerArea.h"
#import <SDCycleScrollView.h>
#import "ProductColorAndCountView.h"

//tools
#import "NSMutableAttributedString+ThroughLine.h"

//models
#import "GoodsDetailSpec_ListModel.h"

@interface ProductDetailHeaderView ()<STPickerAreaDelegate,SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *starBarBGView;
@property (weak, nonatomic) IBOutlet UIView *cycleScrollBGView;
@property (weak, nonatomic) IBOutlet UILabel *labelArea;
@property (weak, nonatomic) IBOutlet UILabel *labelRemark;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelMarketPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelCommentCount;
@property (weak, nonatomic) IBOutlet UILabel *labelSelectedSpecification;
@property (weak, nonatomic) IBOutlet UILabel *labelSelectedCount;



@property (nonatomic, strong)RatingBar *starBar;
@property (nonatomic, strong)STPickerArea *areaPicker;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong)UIView *cloudGlassBGView;
@property (nonatomic, strong)ProductColorAndCountView *productMessageView;

@end

@implementation ProductDetailHeaderView

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
    [self addCycleScollView];
    [self addRatingBar];
    [self initProductMessageView];
    [self respondWithRAC];
}

-(void)setModelInfo:(GoodsDetailGoodsInfoModel *)modelInfo
{
    if (_modelInfo != modelInfo) {
        _modelInfo = modelInfo;
        self.labelProductName.text = _modelInfo.goods_name;
        self.labelRemark.text = _modelInfo.goods_remark;
        self.labelPrice.text = [NSString stringWithFormat:@"¥%@",_modelInfo.price];
        NSMutableAttributedString *throughLineText = [NSMutableAttributedString returnThroughLineWithText:_modelInfo.market_price font:12];
        self.labelMarketPrice.attributedText = throughLineText;
        self.labelCommentCount.text = [NSString stringWithFormat:@"全部评论（%@）",_modelInfo.comment_count];
        self.starBar.starNumber = [_modelInfo.average_score integerValue];
        
        self.productMessageView.goods_id = self.modelInfo.goods_id;
    }
}

-(void)setBannerArray:(NSArray *)bannerArray
{
    if (_bannerArray != bannerArray) {
        _bannerArray = bannerArray;
        self.cycleScrollView.imageURLStringsGroup = _bannerArray;
    }
}

-(void)setSpec_listArray:(NSArray *)spec_listArray
{
    if (_spec_listArray != spec_listArray) {
        _spec_listArray = spec_listArray;
        self.productMessageView.dataArray = _spec_listArray;
        
        //设置默认数据
        NSString *specificationText = @"";
        for (GoodsDetailSpec_ListModel *modelSpecList in _spec_listArray) {
            GoodsDetailSpec_ValueModel *modelSpecValue = modelSpecList.spec_value[0];
            specificationText = [specificationText stringByAppendingFormat:@" %@",modelSpecValue.item];
        }
        self.labelSelectedSpecification.text = specificationText;
        self.labelSelectedCount.text = @"1 件";
    }
}


#pragma mark - <添加cycleScrollView>
-(void)addCycleScollView
{
self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.cycleScrollBGView.bounds delegate:self placeholderImage:[UIImage imageNamed:@"chang"]];
    self.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.cycleScrollView.autoScroll = NO;
    self.cycleScrollView.pageDotColor = kColorFromRGB(kThemeYellow);
    [self.cycleScrollBGView addSubview:self.cycleScrollView];
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - <添加ratingBar>
-(void)addRatingBar
{
    self.starBar = [[RatingBar alloc]initWithFrame:self.starBarBGView.bounds];
    [self.starBarBGView addSubview:self.starBar];
    self.starBar.starNumber = 3;
    self.starBar.enable = NO;
    [self.starBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - <选择送货地点>
- (IBAction)btnSelectArea:(UIButton *)sender
{
    self.areaPicker = [[STPickerArea alloc]init];
    self.areaPicker.delegate = self;
    [self.areaPicker show];
}

#pragma mark - <初始化商品规格选择页面>
-(void)initProductMessageView
{
    self.cloudGlassBGView = [[UIView alloc]initWithFrame:kScreeFrame];
    self.cloudGlassBGView.backgroundColor = kColorFromRGBAndAlpha(kBlack, 0.4);
    
    self.productMessageView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ProductColorAndCountView class]) owner:nil options:nil].lastObject;
    self.productMessageView.frame = CGRectMake(0, kSCREENH_HEIGHT, kSCREEN_WIDTH, 400);
    [self.cloudGlassBGView addSubview:self.productMessageView];
}

#pragma mark - <选择产品颜色和数量>
- (IBAction)btnSelectProductCountAndCountAction:(UIButton *)sender
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.cloudGlassBGView];
    [UIView animateWithDuration:0.3 animations:^{
        self.productMessageView.frame = CGRectMake(0, kSCREENH_HEIGHT-400, kSCREEN_WIDTH, 400);
    }];
}

#pragma mark - <收回商品规格view>
-(void)dismissProductMessageView
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.productMessageView.frame = CGRectMake(0, kSCREENH_HEIGHT, kSCREEN_WIDTH, 400);
    } completion:^(BOOL finished) {
        [self.cloudGlassBGView removeFromSuperview];
    }];
}



#pragma mark - <查看更多评价>
- (IBAction)btnMoreCommentAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"JumpToMoreCommentVC" object:nil];
}

-(void)respondWithRAC
{
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"removeTheView" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self dismissProductMessageView];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"popProductMessageView" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self btnSelectProductCountAndCountAction:nil];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"changeSelectedSpec" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSMutableArray *array = x.object;
        NSString *specificationText = @"";
        for (GoodsDetailSpec_ListModel *modelSpecList in _spec_listArray) {
            for (GoodsDetailSpec_ValueModel *modelSpecValue in modelSpecList.spec_value) {
                for (NSString *id in array) {
                    if ([id isEqualToString:modelSpecValue.item_id]) {
                        specificationText = [specificationText stringByAppendingFormat:@" %@",modelSpecValue.item];
                    }
                }
            }
        }
        self.labelSelectedSpecification.text = specificationText;
    }];
}









#pragma mark - **** STPickerAreaDelegate ****
-(void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area provinceID:(nonnull NSString *)provinceID cityID:(nonnull NSString *)cityID areaID:(nonnull NSString *)areaID
{
    NSMutableArray *array = [NSMutableArray array];
    if (![province isEqualToString:@""]) {
        [array addObject:province];
    }
    if (![city isEqualToString:@""]){
        [array addObject:city];
    }
    if (![area isEqualToString:@""]){
        [array addObject:area];
    }
    
    NSString *string = province;
    for (int i = 1; i < array.count; i++) {
        string = [string stringByAppendingFormat:@">%@",array[i]];
    }
    self.labelArea.text = string;
}

#pragma mark - ***** SDCycleScrollViewDelegate *****
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{

}




@end
