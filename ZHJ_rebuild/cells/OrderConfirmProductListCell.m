//
//  OrderConfirmProductListCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/8.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "OrderConfirmProductListCell.h"

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

@end
