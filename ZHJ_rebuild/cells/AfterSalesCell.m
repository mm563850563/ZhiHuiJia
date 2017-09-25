//
//  AfterSalesCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/31.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "AfterSalesCell.h"

#import "AfterSaleListResultModel.h"

@interface AfterSalesCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewGoods;
@property (weak, nonatomic) IBOutlet UILabel *labelGoodsName;
@property (weak, nonatomic) IBOutlet UILabel *labelGoodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelGoodsSpec;
@property (weak, nonatomic) IBOutlet UILabel *labelGoodsCount;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;

@end

@implementation AfterSalesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModelAfterSaleResult:(AfterSaleListResultModel *)modelAfterSaleResult
{
    _modelAfterSaleResult = modelAfterSaleResult;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@",modelAfterSaleResult.image];
    NSURL *imgURL = [NSURL URLWithString:imgStr];
    [self.imgViewGoods sd_setImageWithURL:imgURL placeholderImage:kPlaceholder];
    
    self.labelGoodsName.text = modelAfterSaleResult.goods_name;
    self.labelGoodsSpec.text = [NSString stringWithFormat:@"%@",modelAfterSaleResult.spec_key_name];
    self.labelGoodsCount.text = [NSString stringWithFormat:@"数量:x%@",modelAfterSaleResult.goods_num];
    self.labelGoodsPrice.text = [NSString stringWithFormat:@"¥%@",modelAfterSaleResult.goods_price];
    
//    0为申请中，1为商家同意退款，2为商家拒绝退款
    NSString *statusStr = [NSString string];
    if ([modelAfterSaleResult.status isEqualToString:@"0"]) {
        statusStr = @"申请中";
    }else if ([modelAfterSaleResult.status isEqualToString:@"1"]){
        statusStr = @"商家同意退款";
    }else if ([modelAfterSaleResult.status isEqualToString:@"-1"]){
        statusStr = @"商家拒绝退款";
    }
    self.labelStatus.text = statusStr;
}















@end
