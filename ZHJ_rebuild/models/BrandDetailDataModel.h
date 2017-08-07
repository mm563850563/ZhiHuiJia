//
//  BrandDetailDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/7.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "BrandDetailResultModel.h"

@interface BrandDetailDataModel : JSONModel

@property (nonatomic, strong)BrandDetailResultModel *result;

@end
