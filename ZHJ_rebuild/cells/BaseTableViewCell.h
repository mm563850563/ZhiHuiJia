//
//  BaseTableViewCell.h
//  ZhiHuiJia
//
//  Created by sophia on 17/7/5.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseModel;

@interface BaseTableViewCell : UITableViewCell

@property (nonatomic, assign)CGFloat height;

#pragma mark - <设置数据>
-(void)setDataWithModel:(BaseModel *)model;





@end
