//
//  ActivityRecommendImageCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityRecommendImageCell : UITableViewCell

@property (nonatomic, strong)NSString *imgStr;
@property (weak, nonatomic) IBOutlet UILabel *labelActivityTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnApplyActivity;

@end
