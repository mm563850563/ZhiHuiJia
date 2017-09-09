//
//  DiscoverBannerDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/9.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "DiscoverBannerResultModel.h"

@protocol DiscoverBannerResultModel <NSObject>
@end

@interface DiscoverBannerDataModel : JSONModel

@property (nonatomic, strong)NSArray<DiscoverBannerResultModel> *result;

@end
