//
//  CartProductListCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/14.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartList_CartListModel.h"

@class SSCheckBoxView;

@protocol CartProductListCellDelegate <NSObject>

-(void)didClickCheckBoxButton:(UIButton *)sender isSelected:(NSString *)isSelected;
-(void)didClickBtnChangeCartNumberWithButton:(UIButton *)sender productCount:(NSString *)productCount isSelected:(NSString *)selected cutPrice:(NSString *)cutPrice isIncrease:(BOOL)isIncrease;

@end

@interface CartProductListCell : UITableViewCell

@property (nonatomic, strong)UIButton *btnCheckBox;
@property (weak, nonatomic) IBOutlet UIView *checkBoxBGView;
@property (nonatomic, strong)SSCheckBoxView *checkBox;
@property (weak, nonatomic) IBOutlet UIButton *btnIncrease;
@property (weak, nonatomic) IBOutlet UIButton *btnDecrease;
@property (weak, nonatomic) IBOutlet UILabel *labelProductCount;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewProduct;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelSpec;
@property (weak, nonatomic) IBOutlet UILabel *labelGoodsPrice;

@property (nonatomic, strong)CartList_CartListModel *model;

@property (nonatomic, weak)id<CartProductListCellDelegate> delegate;

@end
