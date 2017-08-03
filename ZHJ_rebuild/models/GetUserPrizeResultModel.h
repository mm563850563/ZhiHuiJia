//
//  GetUserPrizeResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/3.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GetUserPrize_MyPrizeModel.h"
#import "GetUserPrize_PrizeListModel.h"

@protocol GetUserPrize_PrizeListModel <NSObject>
@end

@interface GetUserPrizeResultModel : JSONModel

@property (nonatomic, strong)GetUserPrize_MyPrizeModel *my_prize;
@property (nonatomic, strong)NSString *activity_rule;
@property (nonatomic, strong)NSString *count;
@property (nonatomic, strong)NSArray<GetUserPrize_PrizeListModel> *prize_list;

@end
