//
//  RankList_circle_rank_infoModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/29.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface RankList_circle_rank_infoModel : JSONModel

@property (nonatomic, strong)NSString *circle_name;
@property (nonatomic, strong)NSString *circle_id;
@property (nonatomic, strong)NSString *logo;
@property (nonatomic, strong)NSString *total_liveness;
@property (nonatomic, strong)NSString *is_attentioned;
@property (nonatomic, strong)NSString *rank;

@end
