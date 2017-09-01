//
//  DiscoverDynamicCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/18.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCircleDynamicResultModel.h"

@interface DiscoverDynamicCell : UITableViewCell

@property (nonatomic, strong)MyCircleDynamicResultModel *modelCircleDynamicResult;
@property (nonatomic, assign)CGFloat cellHeight;



//区别：从哪个页面复用cell
@property (nonatomic, strong)NSString *whereReuseFrom;


@end
