//
//  PersonalLivenessRankResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/1.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "PersonalLivenessRank_ChampionModel.h"
#import "PersonalLivenessRank_personal_rank_infoModel.h"
#import "PersonalLivenessRank_my_first_rank_infoModel.h"

@protocol PersonalLivenessRank_personal_rank_infoModel <NSObject>
@end

@interface PersonalLivenessRankResultModel : JSONModel

@property (nonatomic, strong)NSString *personal_liveness_rule;
@property (nonatomic, strong)NSString *current_month;

@property (nonatomic, strong)PersonalLivenessRank_ChampionModel *personal_rank_champion;
@property (nonatomic, strong)NSArray<PersonalLivenessRank_personal_rank_infoModel> *personal_rank_info;
@property (nonatomic, strong)PersonalLivenessRank_my_first_rank_infoModel *my_first_rank_info;

@end
