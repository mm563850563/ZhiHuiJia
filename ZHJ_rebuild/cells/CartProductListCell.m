//
//  CartProductListCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/14.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "CartProductListCell.h"

//views
#import "SSCheckBoxView.h"

@implementation CartProductListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.checkBox = [[SSCheckBoxView alloc]initWithFrame:self.checkBoxBGView.bounds style:kSSCheckBoxViewStyleGreen checked:YES];
    [self.checkBoxBGView addSubview:self.checkBox];
    self.btnCheckBox = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnCheckBox.frame = self.checkBoxBGView.bounds;
    [self.checkBoxBGView addSubview:self.btnCheckBox];
    [self.btnCheckBox addTarget:self action:@selector(btnSelectCheckBoxAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - <填充数据>
-(void)setModel:(CartList_CartListModel *)model
{
    if (_model != model) {
        _model = model;
        
        NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,model.image];
        NSURL *url = [NSURL URLWithString:imgStr];
        [self.imgViewProduct sd_setImageWithURL:url placeholderImage:kPlaceholder];
        self.labelProductCount.text = model.goods_num;
        self.labelSpec.text = model.key_name;
        self.labelGoodsPrice.text = [NSString stringWithFormat:@"¥ %@",model.goods_price];
        self.labelProductName.text = model.goods_name;
        
        if ([model.selected isEqualToString:@"1"]) {
            self.checkBox.checked = YES;
        }else{
            self.checkBox.checked = NO;
        }
    }
}

- (IBAction)btnProductIncreaseAction:(UIButton *)sender
{
    int count = [self.labelProductCount.text intValue];
    if (count >= 1) {
        count++;
    }
    self.labelProductCount.text = [NSString stringWithFormat:@"%d",count];
    
    if ([self.delegate respondsToSelector:@selector(didClickBtnChangeCartNumberWithButton:productCount:)]) {
        [self.delegate didClickBtnChangeCartNumberWithButton:sender productCount:self.labelProductCount.text];
    }
}

- (IBAction)btnProductDecreaseAction:(UIButton *)sender
{
    int count = [self.labelProductCount.text intValue];
    if (count > 1) {
        count--;
    }
    self.labelProductCount.text = [NSString stringWithFormat:@"%d",count];
    
    if ([self.delegate respondsToSelector:@selector(didClickBtnChangeCartNumberWithButton:productCount:)]) {
        [self.delegate didClickBtnChangeCartNumberWithButton:sender productCount:self.labelProductCount.text];
    }
}

- (void)btnSelectCheckBoxAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickCheckBoxButton:isSelected:)]) {
        self.checkBox.checked = !self.checkBox.checked;
        if (self.checkBox.checked) {
            [self.delegate didClickCheckBoxButton:sender isSelected:@"1"];
        }else{
            [self.delegate didClickCheckBoxButton:sender isSelected:@"0"];
        }
    }
    
}


@end
