//
//  RankListResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/29.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "RankList_circle_rank_infoModel.h"
#import "RankList_my_first_rank_infoModel.h"
#import "RankList_circle_rank_championModel.h"

@protocol RankList_circle_rank_infoModel <NSObject>
@end

@interface RankListResultModel : JSONModel

@property (nonatomic, strong)NSString *circle_liveness_rule;
@property (nonatomic, strong)NSString *current_month;
@property (nonatomic, strong)NSArray<RankList_circle_rank_infoModel> *circle_rank_info;
@property (nonatomic, strong)RankList_my_first_rank_infoModel *my_first_rank_info;
@property (nonatomic, strong)RankList_circle_rank_championModel *circle_rank_champion;

@end
