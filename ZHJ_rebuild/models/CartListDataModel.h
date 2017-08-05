//
//  CartListDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/5.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CartListResultModel.h"


@interface CartListDataModel : JSONModel

@property (nonatomic, strong)CartListResultModel *result;

@end
