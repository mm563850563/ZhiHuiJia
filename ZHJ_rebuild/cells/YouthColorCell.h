//
//  YouthColorCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/13.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YouthColorModel;

@interface YouthColorCell : UITableViewCell

@property (nonatomic, strong)YouthColorModel *model;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic, assign)NSInteger numberOfCell;

@end
