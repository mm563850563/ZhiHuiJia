//
//  AllClassifyDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/27.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "AllClassifyResultModel.h"

@protocol AllClassifyResultModel

@end

@interface AllClassifyDataModel : JSONModel

@property (nonatomic, strong)NSArray<AllClassifyResultModel>*result;

@end
