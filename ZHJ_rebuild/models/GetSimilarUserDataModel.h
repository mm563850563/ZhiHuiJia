//
//  GetSimilarUserDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/4.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GetSimilarUserResultModel.h"

@protocol GetSimilarUserResultModel <NSObject>
@end

@interface GetSimilarUserDataModel : JSONModel

@property (nonatomic, strong)NSArray<GetSimilarUserResultModel> *result;

@end
