//
//  CategoryProductNameCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/28.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AllClassifyResultModel;
@class AllBrandResultModel;

@interface CategoryProductNameCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (nonatomic, strong)AllClassifyResultModel *model;
@property (nonatomic, strong)AllBrandResultModel *brandResultModel;

@end
