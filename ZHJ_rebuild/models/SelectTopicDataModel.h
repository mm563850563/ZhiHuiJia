//
//  SelectTopicDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/4.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "SelectTopicResultModel.h"

@protocol SelectTopicResultModel <NSObject>
@end

@interface SelectTopicDataModel : JSONModel

@property (nonatomic, strong)NSArray<SelectTopicResultModel> *result;

@end
