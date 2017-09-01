//
//  PersonalLivenessRank_my_first_rank_infoModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/1.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PersonalLivenessRank_my_first_rank_infoModel : JSONModel

@property (nonatomic, strong)NSString *user_id;
@property (nonatomic, strong)NSString *nickname;
@property (nonatomic, strong)NSString *total_liveness;
@property (nonatomic, strong)NSString *rank;

@end
