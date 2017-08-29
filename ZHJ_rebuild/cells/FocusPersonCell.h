//
//  FocusPersonCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/19.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCircleDynamicResultModel.h"

@interface FocusPersonCell : UITableViewCell

@property (nonatomic, strong)MyCircleDynamicResultModel *modelCircleDynamicResult;
@property (nonatomic, assign)CGFloat cellHeight;

@end
