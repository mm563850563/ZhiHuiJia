//
//  BrandDetailCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "BrandDetailCell.h"

//views
#import "FlipTableView.h"

//cells

//controllers
#import "AllProductViewController.h"
#import "BrandStoryViewController.h"

//models
#import "BrandDetail_BrandDetailModel.h"

@interface BrandDetailCell ()<FlipTableViewDelegate>

@property (nonatomic, strong)FlipTableView *flipView;
@property (nonatomic, strong)AllProductViewController *allProductVC;
@property (nonatomic, strong)BrandStoryViewController *brandStoryVC;

@end

@implementation BrandDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self setUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self respondWithRAC];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [self setUI];
}

-(void)setUI
{
    [self.contentView addSubview:self.flipView];
    
    [self.flipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"settingCellHeightByBrandDetail" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSNumber *obj = x.object;
        CGFloat cellHeight = [obj floatValue];
        self.cellHeight = cellHeight;
    }];
    self.allProductVC.dataArray = _dataArray;
}

-(void)setModelBrandDetail:(BrandDetail_BrandDetailModel *)modelBrandDetail
{
    if (_modelBrandDetail != modelBrandDetail) {
        _modelBrandDetail = modelBrandDetail;
        self.brandStoryVC.model = modelBrandDetail;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"fillTVStory" object:modelBrandDetail.desc];
    }
}


-(AllProductViewController *)allProductVC
{
    if (!_allProductVC) {
        _allProductVC = [[AllProductViewController alloc]init];
    }return _allProductVC;
}

-(BrandStoryViewController *)brandStoryVC
{
    if (!_brandStoryVC) {
        _brandStoryVC = [[BrandStoryViewController alloc]initWithNibName:NSStringFromClass([BrandStoryViewController class]) bundle:nil];
    }
    return _brandStoryVC;
}


-(FlipTableView *)flipView
{
    if (!_flipView) {
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [array addObject:self.allProductVC];
        [array addObject:self.brandStoryVC];
        
        _flipView = [[FlipTableView alloc]initWithFrame:self.contentView.bounds withArray:array];
        _flipView.delegate = self;
        _flipView.backgroundColor = kColorFromRGB(kLightGray);
    }
    return _flipView;
}

#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"switchSegment_AllProduct_BrandStory" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSNumber *indexNum = x.object;
        NSInteger index = [indexNum integerValue];
        [self.flipView selectIndex:index];
    }];
}










#pragma mark - *** FlipTableViewDelegate ***
-(void)scrollChangeToIndex:(NSInteger)index
{
    NSNumber *indexNum = [NSNumber numberWithInteger:index];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"switchFlip_AllProduct_BrandStory" object:indexNum];
}


@end
