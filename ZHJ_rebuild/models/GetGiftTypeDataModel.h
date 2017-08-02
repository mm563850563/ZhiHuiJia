//
//  GetGiftTypeDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/2.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GetGiftTypeResultModel.h"

@interface GetGiftTypeDataModel : JSONModel

@property (nonatomic, strong)GetGiftTypeResultModel *result;

@end
