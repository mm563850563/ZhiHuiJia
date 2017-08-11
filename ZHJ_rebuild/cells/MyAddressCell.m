//
//  MyAddressCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/20.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MyAddressCell.h"

#import "UserAddressListResultModel.h"
#import "SSCheckBoxView.h"

@interface MyAddressCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelContactName;
@property (weak, nonatomic) IBOutlet UILabel *labelContactPhone;
@property (weak, nonatomic) IBOutlet UILabel *labelAddressDetail;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UIView *checkBoxBGView;

@end

@implementation MyAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self settingOutlets];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)settingOutlets
{
    self.checkBox = [[SSCheckBoxView alloc]initWithFrame:self.checkBoxBGView.bounds style:kSSCheckBoxViewStyleGreen checked:NO];
    [self.checkBoxBGView addSubview:self.checkBox];
    [self.checkBox setStateChangedTarget:self selector:@selector(postNotificationToSetDefaultAddress)];
}

#pragma mark - <发送通知设置默认收货地址>
-(void)postNotificationToSetDefaultAddress
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"setDefaultAddress" object:self.modelResult.address_id];
}



#pragma mark - <删除地址>
- (IBAction)btnDeleteAddressAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DeleteAddressAction" object:self.modelResult.address_id];
}

#pragma mark - <编辑地址>
- (IBAction)btnEditAddressAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"EditAddressAction" object:self.modelResult];
}

#pragma mark - <选择该项cell作为收货地址>
- (IBAction)btnSelectBecomeShippingAddress:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"selectAddress" object:self.modelResult];
}

-(void)setModelResult:(UserAddressListResultModel *)modelResult
{
    if (_modelResult != modelResult) {
        _modelResult =modelResult;
        
        self.labelContactName.text = modelResult.consignee;
        self.labelContactPhone.text = modelResult.mobile;
        self.labelAddressDetail.text = modelResult.area;
        self.labelAddress.text = modelResult.address;
        
        if ([modelResult.is_default isEqualToString:@"1"]) {
            self.checkBox.checked = YES;
        }else{
            self.checkBox.checked = NO;
        }
    }
}



@end
