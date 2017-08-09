//
//  MyAddressCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/20.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserAddressListResultModel;
@class SSCheckBoxView;

@interface MyAddressCell : UITableViewCell

@property (nonatomic, strong)UserAddressListResultModel *modelResult;
@property (nonatomic, strong)SSCheckBoxView *checkBox;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@end
