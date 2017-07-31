//
//  AllBrandDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/31.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "AllBrandResultModel.h"

@protocol AllBrandResultModel <NSObject>
@end

@interface AllBrandDataModel : JSONModel

@property (nonatomic, strong)NSArray<AllBrandResultModel> *result;

@end
