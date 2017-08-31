//
//  DynamicDetailCommentDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/31.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "DynamicDetailCommentResultModel.h"

@protocol DynamicDetailCommentResultModel <NSObject>
@end

@interface DynamicDetailCommentDataModel : JSONModel

@property (nonatomic, strong)NSArray<DynamicDetailCommentResultModel> *result;

@end
