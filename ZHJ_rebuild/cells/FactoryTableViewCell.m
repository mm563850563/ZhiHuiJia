//
//  FactoryTableViewCell.m
//  ZhiHuiJia
//
//  Created by sophia on 17/7/5.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import "FactoryTableViewCell.h"
#import "BaseModel.h"
#import "BaseTableViewCell.h"

@implementation FactoryTableViewCell

+(BaseTableViewCell *)createTableViewCellWithModel:(BaseModel *)model tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    //1.获取cell的名字
    NSString *cellName = NSStringFromClass([model class]);
    //2.创建cell
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
    //3.返回cell
    return cell;
}

@end
