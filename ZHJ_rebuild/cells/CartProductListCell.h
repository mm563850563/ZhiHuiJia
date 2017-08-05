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

@interface CartProductListCell : UITableViewCell

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

@end
