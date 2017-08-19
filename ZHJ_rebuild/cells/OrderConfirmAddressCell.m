//
//  OrderConfirmAddressCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/8.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "OrderConfirmAddressCell.h"
#import "OrderConfirmUserAddressModel.h"

@interface OrderConfirmAddressCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelContactName;
@property (weak, nonatomic) IBOutlet UILabel *labelContactPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnDefaultAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelAddressDetail;
@property (weak, nonatomic) IBOutlet UIButton *btnAddAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelReceiptInformation;
@property (weak, nonatomic) IBOutlet UILabel *labelGoToNext;

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

-(void)setModelUserAddress:(OrderConfirmUserAddressModel *)modelUserAddress
{
    _modelUserAddress = modelUserAddress;
    
    if ([modelUserAddress.address_id isEqualToString:@""]) {
        [self.btnAddAddress setHidden:NO];
        [self.labelReceiptInformation setHidden:YES];
        [self.labelGoToNext setHidden: YES];
        [self.labelContactName setHidden:YES];
        [self.labelContactPhone setHidden:YES];
        [self.labelAddressDetail setHidden:YES];
        [self.btnDefaultAddress setHidden:YES];
    }else{
        if ([modelUserAddress.is_default isEqualToString:@"1"]) {
            [self.btnDefaultAddress setHidden:NO];
        }else{
            [self.btnDefaultAddress setHidden:YES];
        }
        [self.btnAddAddress setHidden:YES];
        
        [self.labelReceiptInformation setHidden:NO];
        [self.labelGoToNext setHidden: NO];
        [self.labelContactName setHidden:NO];
        [self.labelContactPhone setHidden:NO];
        [self.labelAddressDetail setHidden:NO];
        
        self.labelContactName.text = modelUserAddress.consignee;
        self.labelContactPhone.text = modelUserAddress.mobile;
        self.labelAddressDetail.text = [NSString stringWithFormat:@"%@ %@",modelUserAddress.area,modelUserAddress.address];
    }
}

@end
