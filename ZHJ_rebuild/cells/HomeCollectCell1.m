//
//  HomeCollectCell1.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/13.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "HomeCollectCell1.h"
#import "HomeGoodsListModel.h"
#import "RecommendGoodsResultModel.h"
#import "UserFavoriteResultModel.h"
#import "NSMutableAttributedString+ThroughLine.h"

@implementation HomeCollectCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setModel:(HomeGoodsListModel *)model
{
    if (_model != model) {
        _model = model;
        
        NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,model.img];
        NSURL *url = [NSURL URLWithString:imgStr];
        [self.imgProduct sd_setImageWithURL:url placeholderImage:kPlaceholder];
        
        NSString *market = [NSString stringWithFormat:@"某东价:¥%@",model.market_price];
        NSMutableAttributedString *throughLineText = [NSMutableAttributedString returnThroughLineWithText:market];
        self.labelCompare.attributedText = throughLineText;
        
        self.labelProductName.text = model.goods_name;
        self.labelPrice.text = [NSString stringWithFormat:@"¥%@",model.price];
        self.labelProductDetail.text = model.goods_remark;
    }
}

-(void)setModelUserFavorite:(UserFavoriteResultModel *)modelUserFavorite
{
    if (_modelUserFavorite != modelUserFavorite) {
        _modelUserFavorite = modelUserFavorite;
        
        NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelUserFavorite.img];
        NSURL *url = [NSURL URLWithString:imgStr];
        [self.imgProduct sd_setImageWithURL:url placeholderImage:kPlaceholder];
        
        NSString *market = [NSString stringWithFormat:@"某东价:¥%@",modelUserFavorite.market_price];
        NSMutableAttributedString *throughLineText = [NSMutableAttributedString returnThroughLineWithText:market];
        self.labelCompare.attributedText = throughLineText;
        
        self.labelProductName.text = modelUserFavorite.goods_name;
        self.labelPrice.text = [NSString stringWithFormat:@"¥%@",modelUserFavorite.price];
        self.labelProductDetail.text = modelUserFavorite.goods_remark;
    }
}

-(void)setModelRecommendResult:(RecommendGoodsResultModel *)modelRecommendResult
{
    _modelRecommendResult = modelRecommendResult;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelRecommendResult.img];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgProduct sd_setImageWithURL:url placeholderImage:kPlaceholder];
    
    NSString *market = [NSString stringWithFormat:@"某东价:¥%@",modelRecommendResult.market_price];
    NSMutableAttributedString *throughLineText = [NSMutableAttributedString returnThroughLineWithText:market];
    self.labelCompare.attributedText = throughLineText;
    
    self.labelProductName.text = modelRecommendResult.goods_name;
    self.labelPrice.text = [NSString stringWithFormat:@"¥%@",modelRecommendResult.price];
    self.labelProductDetail.text = modelRecommendResult.goods_remark;
}

@end
