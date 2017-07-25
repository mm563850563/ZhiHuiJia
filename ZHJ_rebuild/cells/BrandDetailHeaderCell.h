//
//  BrandDetailHeaderCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandDetailHeaderCell : UITableViewCell

@property (nonatomic, strong)NSArray *dataArray;

@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic) IBOutlet UIImageView *imgBrand;
@property (weak, nonatomic) IBOutlet UILabel *labelStoreName;
@property (weak, nonatomic) IBOutlet UIButton *btnOnlineContact;

@end
