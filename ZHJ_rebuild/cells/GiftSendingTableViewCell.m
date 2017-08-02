//
//  GiftSendingTableViewCell.m
//  ZHJ_rebuild
//
//  Created by sophia on 2017/7/11.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "GiftSendingTableViewCell.h"
#import "GetGiftTypeResultModel.h"
#import "GetGiftType_gift_typeModel.h"

@interface GiftSendingTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgBGView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView3;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (nonatomic, strong)NSMutableArray *imgViewArray;
@property (nonatomic, strong)NSMutableArray *labelArray;

@end

@implementation GiftSendingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSMutableArray *)labelArray
{
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
        [_labelArray addObject:self.label1];
        [_labelArray addObject:self.label2];
        [_labelArray addObject:self.label3];
    }
    return _labelArray;
}

-(NSMutableArray *)imgViewArray
{
    if (!_imgViewArray) {
        _imgViewArray = [NSMutableArray array];
        [_imgViewArray addObject:self.imgView1];
        [_imgViewArray addObject:self.imgView2];
        [_imgViewArray addObject:self.imgView3];
    }
    return _imgViewArray;
}


#pragma mark - <setModel>
-(void)setModel:(GetGiftTypeResultModel *)model
{
    if (_model != model) {
        _model = model;
        for (int i = 0; i<model.gift_type.count; i++) {
            GetGiftType_gift_typeModel *modelList = model.gift_type[i];
            UIImageView *imgView = self.imgViewArray[i];
            UILabel *label = self.labelArray[i];
            
            label.text = modelList.type_name;
            NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelList.logo];
            NSURL *url = [NSURL URLWithString:imgStr];
            [imgView sd_setImageWithURL:url placeholderImage:kPlaceholder];
        }
        NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,model.banner];
        NSURL *url = [NSURL URLWithString:imgStr];
        [self.imgBGView sd_setImageWithURL:url placeholderImage:kPlaceholder];
    }
}


#pragma mark - <注册礼按钮响应>
- (IBAction)btnRegisterGiftAction:(UIButton *)sender
{
    GetGiftType_gift_typeModel *model = self.model.gift_type[0];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RegisterGiftAction" object:model.type_id];
}

#pragma mark - <分享礼按钮响应>
- (IBAction)btnShareGiftAction:(UIButton *)sender
{
    GetGiftType_gift_typeModel *model = self.model.gift_type[1];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ShareGiftAction" object:model.type_id];
}

#pragma mark - <购买礼按钮响应>
- (IBAction)btnBuyGiftAction:(UIButton *)sender
{
    GetGiftType_gift_typeModel *model = self.model.gift_type[2];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"BuyGiftAction" object:model.type_id];
}


@end
