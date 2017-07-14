//
//  HomePageMainCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/12.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageMainCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelProductDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelCompare;
@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;


@end
