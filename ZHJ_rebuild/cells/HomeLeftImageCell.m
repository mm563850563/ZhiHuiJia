//
//  HomeLeftImageCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/13.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "HomeLeftImageCell.h"
#import "NSMutableAttributedString+ThroughLine.h"
#import "HomeGoodsListModel.h"

@interface HomeLeftImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelProductRemark;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelMarketPrice;

@end

@implementation HomeLeftImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(HomeGoodsListModel *)model
{
    if (_model != model) {
        _model = model;
        
        self.labelProductName.text = model.goods_name;
        self.labelPrice.text = model.price;
        self.labelProductRemark.text = model.goods_remark;
        
        NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,model.img];
        NSURL *url = [NSURL URLWithString:imgStr];
        [self.imgProduct sd_setImageWithURL:url placeholderImage:kPlaceholder];
        
        NSMutableAttributedString *throughLineText = [NSMutableAttributedString returnThroughLineWithText:model.market_price font:12];
        self.labelMarketPrice.attributedText = throughLineText;
    }
}

@end
