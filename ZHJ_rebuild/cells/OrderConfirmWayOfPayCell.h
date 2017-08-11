//
//  OrderConfirmWayOfPayCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/8.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSCheckBoxView.h"

@interface OrderConfirmWayOfPayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelWayOfPay;
@property (weak, nonatomic) IBOutlet UIView *checkboxBGView;
@property (nonatomic, strong)SSCheckBoxView *checkBox;
@property (weak, nonatomic) IBOutlet UIImageView *imgWayOfPay;

@property (nonatomic, strong)NSString *wayOfPay;

@end
