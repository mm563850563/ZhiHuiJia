//
//  OrderConfirmProductListCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/8.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "OrderConfirmProductListCell.h"
#import "OrderConfirmGoodsInfoModel.h"

@interface OrderConfirmProductListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgProductList;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelProductDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelProductPrice;

@end

@implementation OrderConfirmProductListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModelGoodsInfo:(OrderConfirmGoodsInfoModel *)modelGoodsInfo
{
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelGoodsInfo.image];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgProductList sd_setImageWithURL:url placeholderImage:kPlaceholder];
    
    self.labelProductName.text = modelGoodsInfo.goods_name;
    self.labelProductPrice.text = [NSString stringWithFormat:@"¥%@ x%@",modelGoodsInfo.price,modelGoodsInfo.goods_num];
    self.labelProductDescription.text = modelGoodsInfo.spec_name;
}


@end
