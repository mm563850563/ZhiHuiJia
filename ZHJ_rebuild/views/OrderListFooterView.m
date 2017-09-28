//
//  OrderListFooterView.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/31.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "OrderListFooterView.h"

@interface OrderListFooterView ()

@property (weak, nonatomic) IBOutlet UIButton *btnCheckLogistic;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnCommit;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnPay;
@property (weak, nonatomic) IBOutlet UILabel *labelFreight;

//@property (nonatomic, strong)

@end

@implementation OrderListFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(void)setModelOrderList:(OrderList_OrderListModel *)modelOrderList
{
    _modelOrderList = modelOrderList;
    
    self.labelProductCount.text = [NSString stringWithFormat:@"共%@件商品",modelOrderList.goods_count];
    self.labelTotalPrice.text = [NSString stringWithFormat:@"合计：¥%@",modelOrderList.goods_price];
    self.labelFreight.text = [NSString stringWithFormat:@"(含运费¥%@)",modelOrderList.freight];
    
    
    if ([modelOrderList.order_status_desc isEqualToString:@"待支付"]) {
        //温馨提示
        {/*亲爱的iOS维护者们，当你看到这段经典的判断，正在思考为什么用文本字符来判断订单状态，而不是订单状态ID，请不要惊讶，因为我们有一个能干的后台，掌握着比基础还要基础的技术水平，扛起这个繁重的后台，真是辛苦了，每天各种高调处理杂碎小问题，彰显自己的技术水平*/
        };
        self.btnCommit.hidden = YES;
        self.btnCheckLogistic.hidden = YES;
        self.btnConfirm.hidden = YES;
        self.btnCancel.hidden = NO;
        self.btnPay.hidden = NO;
        
//#warning ******************************************
//        self.btnCommit.hidden = YES;
//        self.btnCheckLogistic.hidden = YES;
//        self.btnConfirm.hidden = YES;
//        self.btnCancel.hidden = NO;
//        self.btnPay.hidden = YES;
        
        __weak typeof(self) weakSelf = self;
        [self.btnCancel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(70);
        }];
        [self.btnShare mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(weakSelf.btnCancel.mas_left).with.offset(-5);
            make.size.mas_offset(CGSizeMake(50, 20));
        }];
        [self.btnPay mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(weakSelf.btnShare.mas_left).with.offset(-5);
            make.size.mas_offset(CGSizeMake(50, 20));
        }];
        
    }else if ([modelOrderList.order_status_desc isEqualToString:@"待发货"]){
        
//#warning ******************************************
//        self.btnCommit.hidden = YES;
//        self.btnCheckLogistic.hidden = YES;
//        self.btnConfirm.hidden = YES;
//        self.btnCancel.hidden = YES;
//        self.btnPay.hidden = YES;
        
        self.btnCommit.hidden = YES;
        self.btnCheckLogistic.hidden = YES;
        self.btnConfirm.hidden = YES;
        self.btnCancel.hidden = YES;
        self.btnPay.hidden = YES;
        
        [self.btnShare mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-10);
            make.size.mas_offset(CGSizeMake(50, 20));
        }];
    }else if ([modelOrderList.order_status_desc isEqualToString:@"待收货"]){
        
//#warning ************************************************
//        self.btnCommit.hidden = YES;
//        self.btnCheckLogistic.hidden = YES;
//        self.btnConfirm.hidden = NO;
//        self.btnCancel.hidden = YES;
//        self.btnPay.hidden = YES;
        
        self.btnCommit.hidden = YES;
        self.btnCheckLogistic.hidden = NO;
        self.btnConfirm.hidden = NO;
        self.btnCancel.hidden = YES;
        self.btnPay.hidden = YES;
        
        __weak typeof(self) weakSelf = self;
        [self.btnConfirm mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-10);
            make.size.mas_offset(CGSizeMake(70, 20));
        }];
        [self.btnCheckLogistic mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(weakSelf.btnConfirm.mas_left).with.offset(-5);
            make.size.mas_offset(CGSizeMake(70, 20));
        }];
        [self.btnShare mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(weakSelf.btnCheckLogistic.mas_left).with.offset(-5);
            make.size.mas_offset(CGSizeMake(50, 20));
        }];
    }else if ([modelOrderList.order_status_desc isEqualToString:@"待评价"]){
        
//#warning ********************************************
//        self.btnCommit.hidden = NO;
//        self.btnCheckLogistic.hidden = YES;
//        self.btnConfirm.hidden = YES;
//        self.btnCancel.hidden = YES;
//        self.btnPay.hidden = YES;
        
        self.btnCommit.hidden = NO;
        self.btnCheckLogistic.hidden = YES;
        self.btnConfirm.hidden = YES;
        self.btnCancel.hidden = YES;
        self.btnPay.hidden = YES;
        
        __weak typeof(self) weakSelf = self;
        [self.btnCommit mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-10);
            make.size.mas_offset(CGSizeMake(70, 20));
        }];
        [self.btnShare mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(weakSelf.btnCommit.mas_left).with.offset(-5);
            make.size.mas_offset(CGSizeMake(50, 20));
        }];
    }else if ([modelOrderList.order_status_desc isEqualToString:@"已取消"]){
        self.btnCommit.hidden = YES;
        self.btnCheckLogistic.hidden = YES;
        self.btnConfirm.hidden = YES;
        self.btnCancel.hidden = YES;
        self.btnPay.hidden = YES;
        self.btnShare.hidden = YES;
    }else if ([modelOrderList.order_status_desc isEqualToString:@"已完成"]){
        self.btnCommit.hidden = YES;
        self.btnCheckLogistic.hidden = YES;
        self.btnConfirm.hidden = YES;
        self.btnCancel.hidden = YES;
        self.btnPay.hidden = YES;
        
        [self.btnShare mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-10);
            make.size.mas_offset(CGSizeMake(50, 20));
        }];
    }else if ([modelOrderList.order_status_desc isEqualToString:@"已作废"]){
        self.btnCommit.hidden = YES;
        self.btnCheckLogistic.hidden = YES;
        self.btnConfirm.hidden = YES;
        self.btnCancel.hidden = YES;
        self.btnPay.hidden = YES;
        self.btnShare.hidden = YES;
    }
}



- (IBAction)btnShareAction:(UIButton *)sender
{
//    NSString *notifiNameShare = [NSString string];
//    notifiNameShare = @"clickBtnShareFromMyOrderVC";
////    if ([self.whereReuseFrom isEqualToString:@"allOrderListVC"]) {
////        notifiName = @"clickBtnShareFromAllOrderVC";
////    }else if ([self.whereReuseFrom isEqualToString:@"waitToPayVC"]){
////        notifiName = @"clickBtnShareFromWaitToPayVC";
////    }else if ([self.whereReuseFrom isEqualToString:@"waitToSendoutVC"]){
////        notifiName = @"clickBtnShareFromWaitToSendoutVC";
////    }else if ([self.whereReuseFrom isEqualToString:@"sendedGoodsVC"]){
////        notifiName = @"clickBtnShareFromSendedGoodsVC";
////    }else if ([self.whereReuseFrom isEqualToString:@"waitToCommentVC"]){
////        notifiName = @"clickBtnShareFromWaitToCommentVC";
////    }
//    [[NSNotificationCenter defaultCenter]postNotificationName:notifiNameShare object:self.modelOrderList];
    
    if ([self.delegate respondsToSelector:@selector(didClickBtnShare:)]) {
        [self.delegate didClickBtnShare:sender];
    }
}

- (IBAction)btnCheckLogisticsAction:(UIButton *)sender
{
    NSString *order_id = self.modelOrderList.order_id;
    NSString *notifiName = [NSString string];
    if ([self.whereReuseFrom isEqualToString:@"sendedGoodsVC"]) {
        notifiName = @"clickBtnCheckLogisticsFromSendedGoodsVC";
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:notifiName object:order_id];
}

- (IBAction)btnDeleteOrderAction:(UIButton *)sender
{
    NSString *order_id = self.modelOrderList.order_id;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"cancelOrder" object:order_id];
}

- (IBAction)btnCommentAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"presentCommentView" object:self.modelOrderList];
}

- (IBAction)btnConfirmAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"confirmReceipt" object:self.modelOrderList.order_id];
}

- (IBAction)btnPayAction:(UIButton *)sender
{
    NSString *notifiName = [NSString string];
    if ([self.whereReuseFrom isEqualToString:@"allOrderListVC"]) {
        notifiName = @"clickBtnPayFromAllOrderVC";
    }else if ([self.whereReuseFrom isEqualToString:@"waitToPayVC"]){
        notifiName = @"clickBtnPayFromWaitToPayVC";
    }else if ([self.whereReuseFrom isEqualToString:@"waitToSendoutVC"]){
        notifiName = @"clickBtnPayFromWaitToSendoutVC";
    }else if ([self.whereReuseFrom isEqualToString:@"sendedGoodsVC"]){
        notifiName = @"clickBtnPayFromSendedGoodsVC";
    }else if ([self.whereReuseFrom isEqualToString:@"waitToCommentVC"]){
        notifiName = @"clickBtnPayFromWaitToCommentVC";
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:notifiName object:self.modelOrderList];
}








@end
