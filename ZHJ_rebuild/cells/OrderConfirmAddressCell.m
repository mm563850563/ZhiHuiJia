//
//  OrderConfirmAddressCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/8.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "OrderConfirmAddressCell.h"

@interface OrderConfirmAddressCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelContactName;
@property (weak, nonatomic) IBOutlet UILabel *labelContactPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnDefaultAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelAddressDetail;

@end

@implementation OrderConfirmAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
