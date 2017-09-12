//
//  PayTypeView.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/12.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "PayTypeView.h"

@interface PayTypeView ()

@property (weak, nonatomic) IBOutlet UILabel *labelFeeDetail;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectWechat;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectApiPay;

@end

@implementation PayTypeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 */

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.labelFeeDetail.text = self.feeDetail;
    }
    return self;
}

#pragma mark - <选择支付宝支付>
- (IBAction)btnSelectAliPayAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectPayType:)]) {
        [self.delegate didSelectPayType:@"1"];
        self.btnSelectApiPay.selected = YES;
        self.btnSelectWechat.selected = NO;
    }
}

#pragma mark - <选择微信支付>
- (IBAction)btnSelectWechatPayAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectPayType:)]) {
        [self.delegate didSelectPayType:@"2"];
        self.btnSelectApiPay.selected = NO;
        self.btnSelectWechat.selected = YES;
    }
}

#pragma mark - <确定付款>
- (IBAction)btnCorfirmAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickConfirmWithButton:)]) {
        [self.delegate didClickConfirmWithButton:sender];
    }
}

-(void)setFeeDetail:(NSString *)feeDetail
{
    self.labelFeeDetail.text = feeDetail;
}







@end
