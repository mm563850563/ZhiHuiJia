//
//  GetHotCycleResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/21.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GetHotCycleCircleInfoModel.h"

@protocol GetHotCycleCircleInfoModel <NSObject>
@end

@interface GetHotCycleResultModel : JSONModel

@property (nonatomic, strong)NSString *classify_id;
@property (nonatomic, strong)NSString *classify_name;
@property (nonatomic, strong)NSArray<GetHotCycleCircleInfoModel> *circle_info;

@end
