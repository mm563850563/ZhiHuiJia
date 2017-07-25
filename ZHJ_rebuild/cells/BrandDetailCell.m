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

@interface BrandDetailCell ()<FlipTableViewDelegate>

@property (nonatomic, strong)FlipTableView *flipView;

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
//    [self.flipView reloadInputViews];
//    [self.flipView layoutIfNeeded];
//    
//    [self.flipView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(300);
//    }];
}



-(FlipTableView *)flipView
{
    if (!_flipView) {
        AllProductViewController *allProductVC = [[AllProductViewController alloc]init];
        BrandStoryViewController *brandStoryVC = [[BrandStoryViewController alloc]init];
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [array addObject:allProductVC];
        [array addObject:brandStoryVC];
        
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
