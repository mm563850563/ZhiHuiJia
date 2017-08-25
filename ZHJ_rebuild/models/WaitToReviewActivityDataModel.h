//
//  WaitToReviewActivityDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "WaitToReviewActivityResultModel.h"

@protocol WaitToReviewActivityResultModel <NSObject>
@end

@interface WaitToReviewActivityDataModel : JSONModel

@property (nonatomic, strong)NSArray<WaitToReviewActivityResultModel> *result;

@end
