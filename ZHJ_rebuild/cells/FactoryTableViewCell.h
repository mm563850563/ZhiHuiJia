//
//  FactoryTableViewCell.h
//  ZhiHuiJia
//
//  Created by sophia on 17/7/5.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class BaseTableViewCell;
@class BaseModel;

@interface FactoryTableViewCell : NSObject

#pragma mark - <创建cell的工厂类>
+(BaseTableViewCell *)createTableViewCellWithModel:(BaseModel *)model tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
