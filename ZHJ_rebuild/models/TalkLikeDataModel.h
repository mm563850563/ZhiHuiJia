//
//  TalkLikeDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/1.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "TalkLikeResultModel.h"

@protocol TalkLikeResultModel <NSObject>
@end

@interface TalkLikeDataModel : JSONModel

@property (nonatomic, strong)NSArray<TalkLikeResultModel> *result;

@end
