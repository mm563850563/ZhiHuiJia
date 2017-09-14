//
//  MoreProductTableViewCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/1.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MoreProductTableViewCell.h"
#import "RatingBar.h"

//models
#import "ClassifyListResultModel.h"
#import "BrandDetail_BrandGoodsModel.h"

//tools
#import "NSMutableAttributedString+ThroughLine.h"

@interface MoreProductTableViewCell ()

@property (nonatomic, strong)RatingBar *ratingBar;
@property (weak, nonatomic) IBOutlet UIView *ratingBarBGView;
@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelProductRemark;
@property (weak, nonatomic) IBOutlet UILabel *labelProductPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelMarketPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelCommentCount;

@end

@implementation MoreProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(RatingBar *)ratingBar
{
    if (!_ratingBar) {
        _ratingBar = [[RatingBar alloc]initWithFrame:self.ratingBarBGView.bounds];
        _ratingBar.starNumber = 3;
        _ratingBar.enable = NO;
    }
    return _ratingBar;
}

-(void)drawRect:(CGRect)rect
{
    [self.ratingBarBGView addSubview:self.ratingBar];
}

-(void)setModelClassifyList:(ClassifyListResultModel *)modelClassifyList
{
    if (_modelClassifyList != modelClassifyList) {
        _modelClassifyList = modelClassifyList;
        
        NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelClassifyList.img];
        NSURL *imgURL = [NSURL URLWithString:imgStr];
        [self.imgProduct sd_setImageWithURL:imgURL placeholderImage:kPlaceholder];
        
        self.labelProductName.text = modelClassifyList.goods_name;
        self.labelProductRemark.text = modelClassifyList.goods_remark;
        self.labelProductPrice.text = [NSString stringWithFormat:@"¥%@",modelClassifyList.price];
        self.labelCommentCount.text = [NSString stringWithFormat:@"%@条评论",modelClassifyList.comment_count];
        
        NSString *market = [NSString stringWithFormat:@"某东价:¥%@",modelClassifyList.market_price];
        NSMutableAttributedString *marketPriceStr = [NSMutableAttributedString returnThroughLineWithText:market];
        self.labelMarketPrice.attributedText = marketPriceStr;
        self.ratingBar.starNumber = [modelClassifyList.average_score integerValue];
    }
}

-(void)setModelBrandGoods:(BrandDetail_BrandGoodsModel *)modelBrandGoods
{
    _modelBrandGoods = modelBrandGoods;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelBrandGoods.image];
    NSURL *imgURL = [NSURL URLWithString:imgStr];
    [self.imgProduct sd_setImageWithURL:imgURL placeholderImage:kPlaceholder];
    
    self.labelProductName.text = modelBrandGoods.goods_name;
    self.labelProductRemark.text = modelBrandGoods.goods_remark;
    self.labelProductPrice.text = [NSString stringWithFormat:@"¥%@",modelBrandGoods.price];
    self.labelCommentCount.text = [NSString stringWithFormat:@"%@条评论",modelBrandGoods.comment_count];
    
    NSString *market = [NSString stringWithFormat:@"某东价:¥%@",modelBrandGoods.market_price];
    NSMutableAttributedString *marketPriceStr = [NSMutableAttributedString returnThroughLineWithText:market];
    self.labelMarketPrice.attributedText = marketPriceStr;
    self.ratingBar.starNumber = [modelBrandGoods.average_score integerValue];
}





@end
