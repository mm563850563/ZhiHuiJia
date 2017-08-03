//
//  GetGiftListDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/3.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GetGiftListResultModel.h"

@interface GetGiftListDataModel : JSONModel

@property (nonatomic, strong)GetGiftListResultModel *result;

@end
