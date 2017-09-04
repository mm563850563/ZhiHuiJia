//
//  PeopleNearbyDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/4.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "PeopleNearbyResultModel.h"

@protocol PeopleNearbyResultModel <NSObject>
@end

@interface PeopleNearbyDataModel : JSONModel

@property (nonatomic, strong)NSArray<PeopleNearbyResultModel> *result;

@end
